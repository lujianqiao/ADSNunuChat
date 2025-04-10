//
//  STIAPManager.swift
//  ShortTV
//
//  Created by 陈蔚祥 on 2024/8/26.
//

import Foundation
import StoreKit

public class ADSIAPManager: NSObject {
    public typealias Successed = (_ productId: String, _ receipt: String,
                                  _ transaction: SKPaymentTransaction) -> Void
    public typealias Failed = (Error) -> Void
    public typealias Canceled = () -> Void
    public static let shared: ADSIAPManager = .init()
    private var successed: Successed?
    private var failed: Failed?
    private var canceled: Canceled?
    /// 自动续订成功调用
    private var renewSuccessed: Successed?
    private var product: SKProduct?
    private var request: SKProductsRequest?
    private var restoreIsSuc: Bool = false
    private var restoreTransaction: SKPaymentTransaction?
    /// 初始化方法
    private override init() {
        super.init()
    }
    deinit { debugPrint("deinit == \(Self.self)") }
    /// 发起内购支付
    /// - Parameters:
    ///   - productId: 商品id
    ///   - successed: 购买成功的回调
    ///   - failed: 购买失败的回调
    ///   - canceled: 取消购买
    public func pay(productId: String,
                    successed: @escaping Successed,
                    failed: @escaping Failed,
                    canceled: @escaping Canceled) {
        self.successed = successed
        self.failed = failed
        self.canceled = canceled
        let products = Set([productId])
        request = SKProductsRequest(productIdentifiers: products)
        request?.delegate = self
        request?.start()
    }
    public func restore(successed: @escaping Successed,
                        failed: @escaping Failed,
                        canceled: @escaping Canceled) {
        self.successed = successed
        self.failed = failed
        self.canceled = canceled
        SKPaymentQueue.default().restoreCompletedTransactions()
        SKPaymentQueue.default().add(self)
    }
    /// 自动续费的订阅结果
    /// - Parameter successed: 自动续费成功
    public func renew(successed: @escaping Successed) {
        self.renewSuccessed = successed
        SKPaymentQueue.default().add(self)
    }
}
// MARK: SKRequestDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver
extension ADSIAPManager: SKRequestDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for invalidId in response.invalidProductIdentifiers {
            DispatchQueue.main.async {
                self.failed?(ADSIAPError.invalidProduct(-2000, invalidId))
            }
        }
        if let product = response.products.first {
            self.product = product
            let payment = SKMutablePayment(product: product)
            payment.quantity = 1
            payment.applicationUsername = ""
            if let identifier = UIDevice.current.identifierForVendor {
                payment.applicationUsername = identifier.uuidString
            }
            SKPaymentQueue.default().add(payment)
            SKPaymentQueue.default().add(self)
        } else {
            DispatchQueue.main.async {
                self.failed?(ADSIAPError.withoutProduct(-2001))
            }
        }
    }
    
    public func requestDidFinish(_ request: SKRequest) {
        print("iap: requestDidFinish")
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.failed?(error)
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("iap: paymentQueue purchasing")
            case .purchased:
                print("iap: paymentQueue purchased")
                complete(transaction: transaction)
            case .failed:
                print("iap: paymentQueuefailed")
                if let error = transaction.error {
                    DispatchQueue.main.async {
                        self.failed?(error)
                    }
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                print("iap: paymentQueue restored")
                restoreIsSuc = true
                restoreTransaction = transaction
                queue.finishTransaction(transaction)
            case .deferred:
                print("iap: paymentQueue deferred")
            @unknown default: break
            }
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        DispatchQueue.main.async {
            self.failed?(error)
        }
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("iap: paymentQueueRestoreCompletedTransactionsFinished")
        if !restoreIsSuc {
            DispatchQueue.main.async {
                self.failed?(ADSIAPError.restoreFail(-2002))
            }
        } else {
            // 恢复购买成功 重置为false
            if let restoreTransaction = self.restoreTransaction {
                DispatchQueue.main.async {
                    self.restore(transaction: restoreTransaction)
                }
            }
            restoreIsSuc = false
        }
    }
    public func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        
    }
    @available(iOS 11.0, *)
    public func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    @available(iOS 13.0, *)
    public func paymentQueueDidChangeStorefront(_ queue: SKPaymentQueue) {
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        let productIdentifier = transaction.payment.productIdentifier
        let receiptPath = Bundle.main.appStoreReceiptURL?.path
        if let receiptPath = receiptPath,
            !FileManager.default.fileExists(atPath: receiptPath) {
            SKPaymentQueue.default().finishTransaction(transaction)
            DispatchQueue.main.async {
                self.failed?(ADSIAPError.subscribeFail(-2003))
            }
            return
        }
        var receiptData: NSData?
        do {
            receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
        } catch {
            print("iap ERROR: " + error.localizedDescription)
        }
        guard let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) else {
            SKPaymentQueue.default().finishTransaction(transaction)
            DispatchQueue.main.async {
                self.failed?(ADSIAPError.subscribeFail(-2004))
            }
            return
        }
        succ(transaction, productIdentifier, receiptString, false)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let original = transaction.original else {
            SKPaymentQueue.default().finishTransaction(transaction)
            DispatchQueue.main.async {
                self.failed?(ADSIAPError.subscribeFail(-2005))
            }
            return
        }
        let productIdentifier = original.payment.productIdentifier
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
           !FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            SKPaymentQueue.default().finishTransaction(transaction)
            DispatchQueue.main.async {
                self.failed?(ADSIAPError.subscribeFail(-2006))
            }
            return
        }
        var receiptData:NSData?
        do {
            receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
        } catch {
            print("ERROR: " + error.localizedDescription)
        }
        guard let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) else {
            SKPaymentQueue.default().finishTransaction(transaction)
            DispatchQueue.main.async {
                self.failed?(ADSIAPError.subscribeFail(-2007))
            }
            return
        }
        succ(transaction, productIdentifier, receiptString, true)
    }
    
    func succ(_ transaction: SKPaymentTransaction, _ productIdentifier: String, _ receiptString: String, _ isRestore: Bool) {
        print("iap \(isRestore ? "恢复" : "成功")订阅:" + (transaction.transactionIdentifier ?? ""))
        SKPaymentQueue.default().finishTransaction(transaction)
        DispatchQueue.main.async {
            self.successed?(productIdentifier, receiptString, transaction)
            self.renewSuccessed?(productIdentifier, receiptString, transaction)
        }
    }
}
