import UIKit

class ExpandedSubscriptionCell: UITableViewCell {

    @IBOutlet weak var friends: UICollectionView!
    @IBOutlet weak var footer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource &
        UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        friends.delegate = dataSourceDelegate
        friends.dataSource = dataSourceDelegate
        friends.tag = row
        friends.reloadData()
    }
}
