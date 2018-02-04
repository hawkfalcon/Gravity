import UIKit

class SubscriptionCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var friends: UICollectionView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var time: UILabel!
    
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
