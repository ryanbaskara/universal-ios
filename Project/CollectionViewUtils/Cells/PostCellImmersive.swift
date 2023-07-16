import UIKit
import SDWebImage
import FeedKit

class PostCellImmersive: UICollectionViewCell, PostCell {
    
    public static var widthHeightRatio = 0.50
    public static let identifier = "PostCellImmersive"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.masksToBounds = true
    }
    
    var tab: Tab? {
        didSet {
            if let tab = tab {
                imageView.sd_setImage(with: URL(string: (tab.icon)!))
                captionLabel.text = tab.name
                dateLabel.text = ""
            }
        }
    }
    
}
