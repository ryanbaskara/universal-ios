import UIKit
import SDWebImage
import FeedKit

class PostCellText: UICollectionViewCell, PostCell {
    
    public static let identifier = "PostCellText"
        
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
