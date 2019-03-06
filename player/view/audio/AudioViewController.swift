import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class AudioViewController: BaseViewController {   
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        
        let viewModel = self.diResolver.audioListViewModel()
        
        // подписываемся на получение данных
        viewModel.radioStreams
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: AudioItemTableViewCell.CELL_IDENTIFIER, cellType: AudioItemTableViewCell.self)) { [weak self] (_, element, cell) in
                self?.configure(cell: cell, model: element)
            }
            .disposed(by: self.disposeBag)
        
        // обрабатываем нажатие на ячейке
        tableView.rx
            .modelSelected(AudioItemViewModel.self)
            .bind(to: viewModel.selected)
            .disposed(by: self.disposeBag)
        
        // первый раз принудительно загружаем
        viewModel.reload.onNext(())
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
        cell.imageControl.image = UIImage(named: model.playing ? "stopIcon": "playIcon")
    }
}

extension AudioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
