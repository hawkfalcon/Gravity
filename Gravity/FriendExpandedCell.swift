import UIKit

class FriendExpandedCell: UITableViewCell {

    @IBOutlet weak var friends: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        friends.delegate = dataSourceDelegate
        friends.dataSource = dataSourceDelegate
        friends.tag = row
        friends.reloadData()
    }

}
