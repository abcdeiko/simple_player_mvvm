//
//  YoutubePlayerViewController.swift
//  player
//
//  Created by Yuriy on 19/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import UIKit
import AVFoundation
import XCDYouTubeKit

class YoutubePlayerViewController: UIViewController {
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var viewTopControls: UIView!
    
    var videoId: String!
    
    private var playerLayer: AVPlayerLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTopControls.isHidden = true
        
        XCDYouTubeClient.default().getVideoWithIdentifier(videoId) { [weak self] (video, error) in
            guard let self = self, let streamUrl = video?.streamURLs[XCDYouTubeVideoQuality.medium360.rawValue] else { return }

            let playerAV = AVPlayer(url: streamUrl)
            self.playerLayer = AVPlayerLayer(player: playerAV)
            self.playerLayer.frame = self.view.bounds
            self.view.layer.addSublayer(self.playerLayer)
            playerAV.play()
            
            self.view.bringSubviewToFront(self.viewTopControls)
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionTap))
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.btnClose.addTarget(self, action: #selector(actionClose), for: .touchUpInside)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { (context) in
            self.playerLayer.frame = self.view.bounds
        }
    }
    
    @objc private func actionClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func actionTap() {
        self.viewTopControls.isHidden ? self.fadeInControls(): self.fadeOutControls()
    }
    
    private func fadeInControls() {
        self.viewTopControls.alpha = 0
        self.viewTopControls.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.viewTopControls.alpha = 0.55
            self.view.layoutIfNeeded()
        }
    }
    
    private func fadeOutControls() {
        UIView.animate(withDuration: 0.2) {
            
        }
    }
}
