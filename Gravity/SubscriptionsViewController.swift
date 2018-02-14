import UIKit
import ViewAnimator

class SubscriptionsViewController: UITableViewController {
    
    var subscriptions = [
        UserSubscriptionModel(name: "Netflix", icon: "netflix", color:
            UIColor(red: 185, green: 9, blue: 11), cost: 9.99, type: "mo"),
        UserSubscriptionModel(name: "Spotify", icon: "spotify", color:
            UIColor(red: 30, green: 215, blue: 96), cost: 4.99, type: "mo")
        ]
    
    let cellIdentifier = "SubscriptionCell"
    @IBOutlet weak var total: UIBarButtonItem!

    override func viewDidLoad() {
        subscriptions[0].friends = [
            FriendModel(first: "Test", last: "Test", image: "profile1"),
            FriendModel(first: "Test2", last: "Test2", image: "profile2")
        ]
        
        subscriptions[1].friends = [
            FriendModel(first: "T", last: "T", image: "profile")
        ]
                
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        total.title = "Total: $\(calculateTotal())/mo"
        tableView.reloadData()
    }
    
    func calculateTotal() -> Float {
        var monthly: Float = 0.0
        var yearly: Float = 0.0
        for sub in subscriptions {
            if sub.type == "mo" {
                monthly += sub.cost
            } else {
                yearly += sub.cost
            }
        }
        return (monthly + yearly / 12.0).rounded(toPlaces: 2)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return subscriptions.count
    }
    
    var selectedIndex = -1
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == selectedIndex {
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var subscription = subscriptions[indexPath.section]

        var subscriptionSource: TableViewSource = subscription
        if indexPath.row != 0 {
            subscriptionSource = UserFriendsModel(friends: subscription.friends)
        }
        
        return subscriptionSource.cellForTableView(tableView: tableView, atIndexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            guard let cell = cell as? ExpandedSubscriptionCell else {
                fatalError("Cell not found")
            }
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
            return
        }

        guard let cell = cell as? SubscriptionCell else {
            fatalError("Cell not found")
        }
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)

    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return cellSpacingHeight
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 0 {
            return 300
        }
        return 100 //Not expanded
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curIndexPath = IndexPath(row: 1, section: indexPath.section)

        if selectedIndex == indexPath.section {
            selectedIndex = -1
            if let cell = tableView.cellForRow(at: indexPath) as? SubscriptionCell {
                cell.friends.isHidden = false
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: [curIndexPath], with: .automatic)
            tableView.endUpdates()
        } else {
            if selectedIndex != -1 {
                if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: selectedIndex)) as? SubscriptionCell {
                    cell.friends.isHidden = false
                }
                let ipath = IndexPath(row: 1, section: selectedIndex)
                selectedIndex = -1
                tableView.beginUpdates()
                tableView.deleteRows(at: [ipath], with: .automatic)
                tableView.endUpdates()
            }
            selectedIndex = indexPath.section
            if let cell = tableView.cellForRow(at: indexPath) as? SubscriptionCell {
                cell.friends.isHidden = true
                subscriptions[indexPath.section].current = true
            }
            tableView.beginUpdates()
            tableView.insertRows(at: [curIndexPath], with: .automatic)
            tableView.endUpdates()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "facebook") as? FBLoginViewController {
        navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        headerView.backgroundColor = subscriptions[section].color
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
//        footerView.backgroundColor = UIColor.lightGray
//        return footerView
//    }
//
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle:
     UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if let dest = segue.destination as? AddSubscriptionViewController {
            dest.mainVC = self
        }
    }

}

extension SubscriptionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriptions[collectionView.tag].friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tableCell = subscriptions[collectionView.tag]
        let friend = tableCell.friends[indexPath.row]
        
        if tableCell.current {
            return friend.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "FriendCell", for: indexPath) as? FriendCell else {
                fatalError("Cell not found")
        }
        
        let image = UIImage(named: friend.image)
        cell.profile.image = image
        cell.profile.setRounded()
        
        return cell
    }
}

extension Float {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
