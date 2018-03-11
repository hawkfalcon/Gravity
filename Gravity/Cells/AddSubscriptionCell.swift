import UIKit

class AddSubscriptionCell: UICollectionViewCell, Configurable {
    var model: AddSubscriptionViewModel?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWithModel(_ model: AddSubscriptionViewModel) {
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
}
