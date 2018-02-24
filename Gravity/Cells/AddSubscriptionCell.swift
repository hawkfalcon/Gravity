import UIKit

class AddSubscriptionCell: UITableViewCell, Configurable {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var model: AddSubscriptionViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWithModel(_ model: AddSubscriptionViewModel) {
        self.model = model
        
        self.name.text = model.subscription.brand.name
        self.icon.image = model.subscription.brand.icon
        self.layer.borderColor = model.subscription.brand.color.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            let inset: CGFloat = 5
            var frame = newFrame
            frame.origin.x += inset
            frame.size.width -= 2 * inset
            super.frame = frame
        }
    }

}
