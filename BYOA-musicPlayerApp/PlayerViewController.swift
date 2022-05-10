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
        
        // album cover
        albumImageView.frame = CGRect(x: 10,
                                      y: 10,
                                      width: holder.frame.size.width-20,
                                      height: holder.frame.size.width-20)
        albumImageView.image = UIImage(named: song.imageName)
        holder.addSubview(albumImageView)
        
        // Labels: Song name, album, artist
        songNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height+10,
                                     width: holder.frame.size.width-20,
                                     height: 70)
        
        artistNameLabel.frame = CGRect(x: 10,
                                       y: albumImageView.frame.size.height+10+70,
                                       width: holder.frame.size.width-20,
                                       height: 70)
        
        albumNameLabel.frame = CGRect(x: 10,
                                      y: albumImageView.frame.size.height+10+140,
                                      width: holder.frame.size.width-20,
                                      height: 70)
        
        songNameLabel.text = song.name
        artistNameLabel.text = song.artistName
        albumNameLabel.text = song.albumName
        
        holder.addSubview(songNameLabel)
        holder.addSubview(artistNameLabel)
        holder.addSubview(albumNameLabel)
        
        // Player Controlls
        let playPauseButton = UIButton()
        let nextButton = UIButton()
        let backButton = UIButton()
        
        // Frame
        let yPosition = artistNameLabel.frame.origin.y + 70 + 100
        let buttonSize: CGFloat = 70
        let holderWidth: CGFloat = holder.frame.size.width
        
        playPauseButton.frame = CGRect(x: (holderWidth - buttonSize) / 2.0,
                                       y: yPosition,
                                       width: buttonSize,
                                       height: buttonSize)
                
        playPauseButton.frame = CGRect(x: holderWidth - buttonSize - 20,
                                       y: yPosition,
                                       width: buttonSize,
                                       height: buttonSize)
        
        playPauseButton.frame = CGRect(x: 20,
                                       y: yPosition,
                                       width: buttonSize,
                                       height: buttonSize)
        
        // Add Actions
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        // Styling
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)

        playPauseButton.tintColor = .black
        nextButton.tintColor = .black
        backButton.tintColor = .black

        
        holder.addSubview(playPauseButton)
        holder.addSubview(nextButton)
        holder.addSubview(backButton)
        
        // Slider
        
        
    }
    
    @objc func didTapPlayPauseButton() {
        
    }
    @objc func didTapNextButton() {
        
    }
    @objc func didTapBackButton() {
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
    
}
