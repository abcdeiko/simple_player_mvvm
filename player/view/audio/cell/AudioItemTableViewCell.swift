//
//  AudioItemTableViewCell.swift
//  player
//
//  Created by Yuriy on 16/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import UIKit

class AudioItemTableViewCell: UITableViewCell {
    
    static let CELL_IDENTIFIER = "audioCell"
    
    @IBOutlet weak var imageControl: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        labelTitle.text = "adsf"        
    }
}
