import UIKit
import Hero

class SubscriptionCell: UITableViewCell, Configurable {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var colorBar: UIView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var footer: UIView!
    
    @IBOutlet weak var friends: UICollectionView!
    
    var model: SubscriptionViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
    }
    
    func configureWithModel(_ model: SubscriptionViewModel) {
        self.model = model

        self.name.text = model.subscription.brand.name
        self.icon.image = model.subscription.brand.icon
        self.cost.text = "$\(model.subscription.cost)"
        self.type.text = "/\(model.subscription.type)"
        
        self.colorBar.backgroundColor = model.subscription.brand.color
        self.colorBar.frame.size.width /= 1.5
        
        self.header.backgroundColor = .clear
        self.footer.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
        
        self.hero.id = model.subscription.brand.name
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource &
        UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        friends.delegate = dataSourceDelegate
        friends.dataSource = dataSourceDelegate
        friends.tag = row
        friends.reloadData()
    }
}
