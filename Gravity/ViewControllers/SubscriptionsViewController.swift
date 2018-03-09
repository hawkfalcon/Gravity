import UIKit

class SubscriptionsViewController: UITableViewController {
    
    var subscriptionModels = [
        SubscriptionViewModel(subscription: Subscription(id: 0, brand:
            Brand(name: "Netflix", icon: "netflix", color:
                UIColor(red: 185, green: 9, blue: 11)),
            cost: 9.99, type: "mo")),
        SubscriptionViewModel(subscription: Subscription(id: 1, brand:
            Brand(name: "Spotify", icon: "spotify", color:
                UIColor(red: 30, green: 215, blue: 96)),
            cost: 4.99, type: "mo"))
        ]
    
    @IBOutlet weak var total: UIBarButtonItem!

    override func viewDidLoad() {
        // Temporary friend data
        subscriptionModels[0].friends = [
            FriendModel(first: "Test", last: "Test", image: "profile1"),
            FriendModel(first: "Test2", last: "Test2", image: "profile2")
        ]
        
        subscriptionModels[1].friends = [
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
        for subModel in subscriptionModels {
            let sub = subModel.subscription
            if sub.type == "mo" {
                monthly += sub.cost
            } else {
                yearly += sub.cost
            }
        }
        return (monthly + yearly / 12.0).rounded(toPlaces: 2)
    }

    // keep track of single selected cell
    var currentlySelected = -1
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == currentlySelected {
            return 2
        }
        return 1
    }
    
    // TODO: clean up selection 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curIndexPath = IndexPath(row: 1, section: indexPath.section)

        if currentlySelected == indexPath.section {
            currentlySelected = -1
            if let cell = tableView.cellForRow(at: indexPath) as? SubscriptionCell {
                cell.friends.isHidden = false
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: [curIndexPath], with: .automatic)
            tableView.endUpdates()
        } else {
            if currentlySelected != -1 {
                if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: currentlySelected)) as? SubscriptionCell {
                    cell.friends.isHidden = false
                }
                let ipath = IndexPath(row: 1, section: currentlySelected)
                currentlySelected = -1
                tableView.beginUpdates()
                tableView.deleteRows(at: [ipath], with: .automatic)
                tableView.endUpdates()
            }
            currentlySelected = indexPath.section
            if let cell = tableView.cellForRow(at: indexPath) as? SubscriptionCell {
                cell.friends.isHidden = true
                subscriptionModels[indexPath.section].current = true
            }
            tableView.beginUpdates()
            tableView.insertRows(at: [curIndexPath], with: .automatic)
            tableView.endUpdates()
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    // temporary fake facebook login
    @IBAction func login(_ sender: Any) {
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "facebook") as? FBLoginViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // when we go to the next view, keep reference to main view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? AddSubscriptionViewController {
            dest.mainVC = self
        }
    }
}

// MARK: - UITableViewDataSource
extension SubscriptionsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return subscriptionModels.count
    }
    
    // Dequeue cells using TableViewSource compliant models
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let subscription = subscriptionModels[indexPath.section]
        
        var subscriptionSource: TableCellRepresentable = subscription
        if indexPath.row != 0 {
            subscriptionSource = UserFriendsModel(friends: subscription.friends)
        }
        
        return subscriptionSource.cellForTableView(tableView: tableView, atIndexPath: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension SubscriptionsViewController {
    // Set up size and footer
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 0 {
            return 300
        }
        return 105 //Not expanded
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 10))
        footerView.backgroundColor = .clear
        return footerView
    }
}

// Populate friend images and names for collection views
extension SubscriptionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriptionModels[collectionView.tag].friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // tag was previously set to cell section index
        let tableCell = subscriptionModels[collectionView.tag]
        let friend = tableCell.friends[indexPath.row]
        
        // dequeue for expanded friend cell
        if tableCell.current {
            return friend.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        }
        
        // dequeue for friend cell
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
