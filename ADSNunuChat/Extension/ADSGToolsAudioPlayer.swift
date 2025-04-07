//
//  ADSGToolsAudioPlayer.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/3/14.
//

import UIKit
import AVFoundation

class ADSGToolsAudioPlayer: NSObject {

    public static let shared = ADSGToolsAudioPlayer()
    
    var audioPlayer: AVAudioPlayer?
    
    func playAudioWithUrl(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 1.0
            audioPlayer?.prepareToPlay()
            
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
}
