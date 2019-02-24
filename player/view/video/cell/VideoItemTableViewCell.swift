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
