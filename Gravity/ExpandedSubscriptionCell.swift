import UIKit

class ExpandedSubscriptionCell: UITableViewCell {

    @IBOutlet weak var friends: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource &
        UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        friends.delegate = dataSourceDelegate
        friends.dataSource = dataSourceDelegate
        friends.tag = row
        friends.reloadData()
    }

}
