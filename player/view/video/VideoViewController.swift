//
//  VideoViewController.swift
//  player
//
//  Created by Yuriy on 16/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import UIKit
import SDWebImage

//https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=PL6gx4Cwl9DGBsvRxJJOzG4r4k_zLKrnxl&key=AIzaSyAGoC8WLQ_mh9uiXc4fPrFa4f-P37oVyks

class VideoViewController: UIViewController {
    
    let items: [ModelYoutubeVideoInfo] = [
        ModelYoutubeVideoInfo(
            title: "Android App Development for Beginners - 1 - Introduction",
            thumbnailUrl: "https://i.ytimg.com/vi/QAbQgLGKd3Y/sddefault.jpg",
            videoId: "QAbQgLGKd3Y"
        ),
        ModelYoutubeVideoInfo(
            title: "Android App Development for Beginners - 2 - Installing Android Studio",
            thumbnailUrl: "https://i.ytimg.com/vi/zEsDwzjPJ5c/sddefault.jpg",
            videoId: "zEsDwzjPJ5c")
    ]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
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
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension VideoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = YoutubePlayerViewController(nibName: "YoutubePlayerViewController", bundle: nil)
        vc.videoId = items[indexPath.row].videoId
        self.present(vc, animated: true, completion: nil)
    }
}

extension VideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VideoItemTableViewCell! = tableView.dequeueReusableCell(withIdentifier: VideoItemTableViewCell.CELL_IDENTIFIER) as? VideoItemTableViewCell
        
        if let thumbUrl = items[indexPath.row].thumbnailUrl {
            cell.imageThumbnail!.sd_setImage(with: URL(string: thumbUrl), placeholderImage: UIImage(named: "videoPlaceholder"), options: [], completed: nil)
        }
        
        return cell
    }
}
