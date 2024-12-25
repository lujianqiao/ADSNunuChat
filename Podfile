# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'


target 'ADSNunuChat' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ADSNunuChat
  pod 'Alamofire'
  pod 'Moya'
  pod 'SnapKit'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'TZImagePickerController'
  pod 'JXBanner'
  # 自动管理键盘
  pod 'IQKeyboardManagerSwift', '6.2.1'
  pod 'SmartCodable'
  # 富文本
  pod 'RZColorfulSwift', '~>0.3.0'

  # Rx全家桶
  pod 'RxSwift', '6.6.0'
  pod 'RxCocoa', '6.6.0'
  pod 'RxDataSources', '5.0.0'
  pod 'RxGesture', '4.0.4'
  pod 'NSObject+Rx', '5.2.2'
  
  
  target 'ADSNunuChatTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ADSNunuChatUITests' do
    # Pods for testing
  end

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
