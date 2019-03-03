import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class VideoViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        
        let viewModel = self.diResolver.videoListViewModel()
        
        // подписываемся на отображение загруженных элементов
        viewModel.videos
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: VideoItemTableViewCell.CELL_IDENTIFIER, cellType: VideoItemTableViewCell.self)) { [weak self] (_, element, cell) in
                self?.configure(cell: cell, model: element)
            }
            .disposed(by: self.disposeBag)
        
        // первый раз релоадим таблицу самостоятельно
        viewModel.reload.onNext(())
        
        // обработка нажатия на элемент
        tableView.rx.modelSelected(VideoItemViewModel.self)
        .bind(to: viewModel.selectVideo)
        .disposed(by: self.disposeBag)
        
        // открытие плеера
        viewModel.showVideoById            
            .subscribe(onNext: { [weak self] in
                self?.presentPlayerWith(videoId: $0)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func configureView() {
        tableView.register(
            UINib(
                nibName: "VideoItemTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: VideoItemTableViewCell.CELL_IDENTIFIER
        )
        
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    private func presentPlayerWith(videoId: String) {
        let vc = self.diResolver.youtubePlayerView(videoId: videoId)        
        self.present(vc, animated: true, completion: nil)
    }
    
    private func configure(cell: VideoItemTableViewCell, model: VideoItemViewModel) {
        cell.labelTitle.text = model.title
        
        if let thumbUrl = model.thumbnailUrl {
            cell.imageThumbnail!.sd_setImage(
                with: URL(string: thumbUrl),
                placeholderImage: UIImage(named: "videoPlaceholder"),
                options: [],
                completed: nil
            )
        }
    }
}

extension VideoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
