//
//  PlayerViewController.swift
//  BYOA-musicPlayerApp
//
//  Created by Sava Danchev on 5/6/22.
//

import AVFoundation
import UIKit

class PlayerViewController: UIViewController {

    public var position: Int = 0
    public var songs: [Song] = []
    
    @IBOutlet var holder: UIView!
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0 {
            configure()
        }
    }

    func configure() {
        // set up player
        let song = songs[position]
        
        let songFilePath = Bundle.main.path(forResource: song.trackName, ofType: "mp3") // Looks for file in project root folder
        
        print("Loding resource: \(songFilePath!)")
        
        do {
            guard let songFilePath = songFilePath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let songUrl = URL(string: songFilePath) else {
                print("song file path is invalid")
                return
            }
            
            print("Loding resource from URL: \(songUrl)")
            
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            player = try AVAudioPlayer(contentsOf: songUrl)
            
            guard let player = player else {
                print("player is nil")
                return
            }
            player.volume = 0.5
            player.play()
            
        }
        catch {
            print("error occurred")
        }
        
        // set up user interface elements
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
    
}
