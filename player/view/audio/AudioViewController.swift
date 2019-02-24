import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class AudioViewController: BaseViewController {   
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var player: StreamPlayer = StreamPlayer()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        
        let viewModel = self.diResolver.audioListViewModel()
        
        // подписываемся на получение данных
        viewModel.radioStreams
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: AudioItemTableViewCell.CELL_IDENTIFIER, cellType: AudioItemTableViewCell.self)) { [weak self] (_, element, cell) in
                self?.configure(cell: cell, model: element)
            }
            .disposed(by: self.disposeBag)
        
        // первый раз принудительно загружаем
        viewModel.reload.onNext(())
        
        tableView.rx
            .modelSelected(AudioItemViewModel.self)
            //.subscribe(onNext: {})
        
        //RxTableViewSectionedAnimatedDataSource
    }
    
    private func configureView() {
        tableView.register(
            UINib(
                nibName: "AudioItemTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: AudioItemTableViewCell.CELL_IDENTIFIER
        )
        
        tableView.delegate = self        
        tableView.tableFooterView = UIView()
    }
    
    private func configure(cell: AudioItemTableViewCell, model: AudioItemViewModel) {
        cell.labelTitle.text = model.title
    }
}

extension AudioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        player.playFrom(streamURL: AudioViewController.items[indexPath.row])
    }
}
