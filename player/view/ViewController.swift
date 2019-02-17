//
//  ViewController.swift
//  player
//
//  Created by Yuriy on 14/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private static let INDEX_AUDIO: Int = 0
    private static let INDEX_VIDEO: Int = 1
    

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var viewContainer: UIView!
    
    private var currentVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControl.removeAllSegments()
        segmentControl.insertSegment(withTitle: NSLocalizedString("SegmentOne", comment: ""), at: 0, animated: false)
        segmentControl.insertSegment(withTitle: NSLocalizedString("SegmentTwo", comment: ""), at: 1, animated: false)
        segmentControl.addTarget(self, action: #selector(segmentIndexChanged(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = ViewController.INDEX_AUDIO
        segmentIndexChanged(segmentControl)
    }
    
    @objc private func segmentIndexChanged(_ sender:UISegmentedControl) {
        let newVC: UIViewController
        
        switch sender.selectedSegmentIndex {
        case ViewController.INDEX_AUDIO:
            newVC = AudioViewController(nibName: "AudioViewController", bundle: nil)
        case ViewController.INDEX_VIDEO:
            newVC = VideoViewController(nibName: "VideoViewController", bundle: nil)
        default:
            return
        }
        
        // emulate VC lifecycle
        if let currentVC = currentVC {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
            currentVC.didMove(toParent: nil)
        }
        
        newVC.willMove(toParent: self)
        addChild(newVC)
        viewContainer.addSubview(newVC.view)
        newVC.view.frame = viewContainer.bounds
        newVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newVC.didMove(toParent: self)
        
        currentVC = newVC
    }
}

