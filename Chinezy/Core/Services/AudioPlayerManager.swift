import SwiftUI
import Foundation
import AVFoundation
import Combine

class AudioPlayerManager: ObservableObject {
    var player: AVAudioPlayer?
    
    func playSound(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
            print("Error: Could not find \(filename).mp3 in the project.")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
