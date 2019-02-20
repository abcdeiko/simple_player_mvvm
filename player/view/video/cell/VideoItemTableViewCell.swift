//
//  VideoItemTableViewCell.swift
//  player
//
//  Created by Yuriy on 19/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import UIKit

class VideoItemTableViewCell: UITableViewCell {
    
    static let CELL_IDENTIFIER = "videoCell"
    
    @IBOutlet weak var imageThumbnail: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
