import UIKit
import SDWebImage
import FeedKit

class PostCellLarge: UICollectionViewCell, PostCell {
    
    public static var widthHeightRatio = 0.60
    public static var widthHeightRatioRelated = 1.5
    public static var widthHeightRatioRelatedVideo = 0.7
    public static let identifier = "PostCellLarge"
    
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var captionLabel: UILabel!
    @IBOutlet fileprivate weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
    }
    
    
}
