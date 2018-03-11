import UIKit
import SwipeCellKit
import Hero

class SubscriptionCell: SwipeTableViewCell, Configurable {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var colorBar: UIView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var footer: UIView!
    
    @IBOutlet weak var friends: UICollectionView!
    @IBOutlet weak var expandedFriends: UICollectionView!
    
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
        self.footer.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
        
        self.hero.id = model.subscription.brand.name
        self.expandedFriends.isHidden = true
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource &
        UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        setDelegate(collection: friends, dataSourceDelegate: dataSourceDelegate, row: row)
        setDelegate(collection: expandedFriends, dataSourceDelegate: dataSourceDelegate, row: row)
    }
    
    func setDelegate<D: UICollectionViewDataSource &
        UICollectionViewDelegate>(collection: UICollectionView, dataSourceDelegate: D, row: Int) {
        collection.delegate = dataSourceDelegate
        collection.dataSource = dataSourceDelegate
        collection.tag = row
        collection.reloadData()
    }
}
