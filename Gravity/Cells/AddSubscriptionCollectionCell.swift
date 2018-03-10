import UIKit

class AddSubscriptionCollectionCell: UICollectionViewCell, Configurable {
    var model: AddSubscriptionCollectionViewModel?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWithModel(_ model: AddSubscriptionCollectionViewModel) {
        self.model = model
        
        self.name.text = model.subscription.brand.name
        self.icon.image = model.subscription.brand.icon
        
        self.backgroundColor = .white
        self.layer.borderColor = model.subscription.brand.color.cgColor
        self.name.textColor = model.subscription.brand.color
        
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 2.0
        self.layer.masksToBounds = true
    }
    
    override var isSelected: Bool {
        didSet {
//            if self.isSelected {
//                self.transform = CGAffineTransform(scaleX: 2.1, y: 2.1)
//                self.contentView.backgroundColor = UIColor.red
//                //self.tickImageView.isHidden = false
//            } else {
//                self.transform = CGAffineTransform.identity
//                self.contentView.backgroundColor = UIColor.gray
//               // self.tickImageView.isHidden = true
//            }
        }
    }
}
