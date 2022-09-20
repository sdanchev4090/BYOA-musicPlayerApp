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
    
    // User Interface Elements
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 // line wrap
        return label
    }()
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 // line wrap
        return label
    }()
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 // line wrap
        return label
    }()
    let playPauseButton = UIButton()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.overrideUserInterfaceStyle = .dark
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
        
        // album cover
        albumImageView.frame = CGRect(x: 30,
                                      y: 30,
                                      width: holder.frame.size.width-60,
                                      height: holder.frame.size.width-60)
        albumImageView.image = UIImage(named: song.imageName)
        albumImageView.layer.cornerRadius = 25
        albumImageView.clipsToBounds = true
        holder.addSubview(albumImageView)
        
        // Labels: Song name, Artist, Album
        songNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height+65,
                                     width: holder.frame.size.width-20,
                                     height: 50)
        
        artistNameLabel.frame = CGRect(x: 10,
                                       y: albumImageView.frame.size.height+40+65,
                                       width: holder.frame.size.width-20,
                                       height: 50)
        
//        albumNameLabel.frame = CGRect(x: 10,
//                                      y: albumImageView.frame.size.height+40+100,
//                                      width: holder.frame.size.width-20,
//                                      height: 50)
        
        songNameLabel.text = song.name
        artistNameLabel.text = song.artistName
//        albumNameLabel.text = song.albumName
        
        songNameLabel.font = UIFont(name: "Helvetica-Bold", size: 25)
        artistNameLabel.font = UIFont(name: "Helvetica", size: 20)
//        albumNameLabel.font = UIFont(name: "Helvetica", size: 20)
        
        songNameLabel.textColor = .white
        artistNameLabel.textColor = .lightGray
        
        holder.addSubview(songNameLabel)
        holder.addSubview(artistNameLabel)
//        holder.addSubview(albumNameLabel)
        
        // Player Controlls
        let nextButton = UIButton()
        let backButton = UIButton()
        
        // Frame
        let yPosition = artistNameLabel.frame.origin.y + 70 + 150
        let buttonSizePP: CGFloat = 90
        let buttonSizeNB: CGFloat = 40
        
        playPauseButton.frame = CGRect(x: (holder.frame.size.width - buttonSizePP) / 2.0,
                                       y: yPosition - ((buttonSizePP - buttonSizeNB) / 2.0),
                                       width: buttonSizePP,
                                       height: buttonSizePP)
                
        nextButton.frame = CGRect(x: holder.frame.size.width - (buttonSizeNB * 1.5) - 72,
                                  y: yPosition,
                                  width: buttonSizeNB * 1.5,
                                  height: buttonSizeNB)
        
        backButton.frame = CGRect(x: 72,
                                  y: yPosition,
                                  width: buttonSizeNB * 1.5,
                                  height: buttonSizeNB)
        
        // Add Actions
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        // Styling
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        playPauseButton.tintColor = UIColor(named: "AccentColor")
        nextButton.tintColor = .white
        backButton.tintColor = .white

        
        holder.addSubview(playPauseButton)
        holder.addSubview(nextButton)
        holder.addSubview(backButton)
        
        // Volume Slider
        
        
    }
    
    @objc func didTapPlayPauseButton() {
        if player?.isPlaying == true {
            // pause
            player?.pause()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)

            // shrink image
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 90,
                                                   y: 90,
                                                   width: self.holder.frame.size.width-180,  // x times 2
                                                   height: self.holder.frame.size.width-180)  // x times 2
            })
        }
        else {
            // play
            player?.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)

            // enlarge image
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 30,
                                                   y: 30,
                                                   width: self.holder.frame.size.width-60,  // x times 2
                                                   height: self.holder.frame.size.width-60)  // x times 2
            })
        }
    }
    @objc func didTapNextButton() {
        if position < (songs.count - 1) {
            position = position + 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
        else {
            position = 0
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    @objc func didTapBackButton() {
        if position > 0 {
            position = position - 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
        else if position == 0 {
            position = songs.count - 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
    
}
