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
            
        let viewModel = self.diResolver.youtubePlayerViewModel()
        
        viewModel.videoLayer
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
        
        viewModel.controlTag
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                let image = $0 == .play ? "playerControlPlay": "playerControlPause"
                self.btnPlay.setImage(UIImage(named: image), for: .normal)
            })
        .disposed(by: self.disposeBag)
        
        // клик по кнопке закрыть
        self.btnClose.rx
            .tap
            .bind(to: viewModel.tapCloseVideo)
            .disposed(by: self.disposeBag)
        
        // тап по кнопке пауза/проиграть
        self.btnPlay.rx
            .tap
            .flatMap { [weak self] in
                return Observable.just(self?.btnPlay.tag)
            }
            .bind(to: viewModel.tapControl)
            .disposed(by: self.disposeBag)
        
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionTap))
        self.view.addGestureRecognizer(tapRecognizer)
        
        //tapRecognizer.rx.event.bind
        
        // загружаем видео
        viewModel.playVideo.onNext(self.videoId)
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
        UIView.animate(withDuration: 0.3, animations: {
            self.viewTopControls.alpha = 0
            
            self.view.layoutIfNeeded()
        }) { (completed) in
            if completed {
                self.viewTopControls.isHidden = true
            }
        }
    }
}
