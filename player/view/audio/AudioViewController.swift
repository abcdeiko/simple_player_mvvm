//
//  VideoViewController.swift
//  player
//
//  Created by Yuriy on 16/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import UIKit

class AudioViewController: UIViewController {
    
    static let items = [
        "http://bigtunesradio.com:8000/bass.mp3",
        "http://airspectrum.cdnstream1.com:8018/1606_192",
        "http://uk7.internet-radio.com:8226/;stream"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var player: StreamPlayer = StreamPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
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
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension AudioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        player.playFrom(streamURL: AudioViewController.items[indexPath.row])
    }
}

extension AudioViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AudioItemTableViewCell! = tableView.dequeueReusableCell(withIdentifier: AudioItemTableViewCell.CELL_IDENTIFIER) as? AudioItemTableViewCell        
        return cell
    }
}
