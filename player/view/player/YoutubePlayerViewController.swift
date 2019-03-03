import UIKit
import AVFoundation
import XCDYouTubeKit
import RxSwift

class YoutubePlayerViewController: BaseViewController {
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var viewTopControls: UIView!
    
    var videoId: String!
    
    private var playerLayer: AVPlayerLayer!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTopControls.isHidden = true
            
        let viewModel = YoutubeViewModel(player: StreamPlayer(), videoProvider: YoutubeVideoProvider())
        
        viewModel.showVideoLayer
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.playerLayer = $0
                self.playerLayer.frame = self.view.bounds
                self.view.layer.addSublayer(self.playerLayer)
                self.view.bringSubviewToFront(self.viewTopControls)
            })
            .disposed(by: self.disposeBag)
        
        viewModel.close
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.playerLayer.removeFromSuperlayer()
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        self.btnClose.rx
            .tap
            .bind(to: viewModel.stopVideo)
            .disposed(by: self.disposeBag)
        
        
        
        viewModel.playVideo.onNext(self.videoId)        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionTap))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { (context) in
            self.playerLayer.frame = self.view.bounds
        }
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
