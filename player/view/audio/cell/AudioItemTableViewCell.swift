import UIKit

class AudioItemTableViewCell: UITableViewCell {
    
    static let CELL_IDENTIFIER = "audioCell"
    
    @IBOutlet weak var imageControl: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }
}
