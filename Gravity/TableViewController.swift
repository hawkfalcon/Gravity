import UIKit
import FirebaseDatabase

class TableViewController: UITableViewController {
    
//    let subscriptions = [
//        Subscription(name: "Netflix", icon: "netflix", color: Color(r: 185, g: 9, b: 11).uiColor(), price: 10.0, time: "mo"),
//        Subscription(name: "Spotify", icon: "spotify", color: Color(r: 30, g: 215, b: 96).uiColor(), price: 12.0, time: "mo")
//    ]
    
    var subscriptions = [Subscription]()

    let cellIdentifier = "SubscriptionCell"

    override func viewDidLoad() {
        
        FIRDatabase.database().reference().child("subscriptions").observeSingleEvent(of: .value, with: { (snapshot) in
            if let subscriptiondict = snapshot.value as? NSDictionary {
                print(subscriptiondict)
                for entry in subscriptiondict.allValues {
                    if let subscriptionvalue = entry as? NSDictionary{
                        self.subscriptions.append(
                            Subscription(
                                name: subscriptionvalue["name"] as? String ?? "COMPANY NAME",
                                icon: subscriptionvalue["icon"] as? String ?? "ICON",
                                color: Color(
                                    r: subscriptionvalue["r"] as! CGFloat,
                                    g: subscriptionvalue["g"] as! CGFloat,
                                    b: subscriptionvalue["b"] as! CGFloat
                                ).uiColor(),
                                cost: subscriptionvalue["cost"] as? Float ?? -1.0,
                                type: subscriptionvalue["type"] as? String ?? "TYPE"))
                    }
                    
                }
                
                
                self.tableView.reloadData()
                
                
                
            }
            else {
                fatalError("No snapshot values :(")
            }
        }, withCancel: { error in
            print(error.localizedDescription)
            
        }
        )
        print(subscriptions.count)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        super.viewDidLoad()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
        
        if indexPath.row != 0 {
            return tableView.dequeueReusableCell(withIdentifier: "largeCell", for: indexPath)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SubscriptionCell else {
            fatalError("Cell not found")
        }
        
        let sub = subscriptions[indexPath.section]
        cell.label.text = sub.name
        
        cell.icon.image = UIImage(named: sub.name.lowercased().replacingOccurrences(of: " ", with: ""))
        cell.price.text = "$\(sub.cost)"
        cell.time.text = "/\(sub.type)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            guard let cell = cell as? FriendExpandedCell else {
                fatalError("Cell not found")
            }
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            return
        }

        guard let cell = cell as? SubscriptionCell else {
            fatalError("Cell not found")
        }
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)

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
            }
            tableView.beginUpdates()
            tableView.insertRows(at: [curIndexPath], with: .automatic)
            tableView.endUpdates()
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag != 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigProfile", for: indexPath) as? BigProfileCell else {
                fatalError("Cell not found")
            }
            
            let image = UIImage(named: "profile")
            cell.profile.image = image
            cell.profile.setRounded()
            cell.name.text = "Friend A"
            
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            fatalError("Cell not found")
        }
        
        let image = UIImage(named: "profile")
        cell.profile.image = image
        cell.profile.setRounded()
        
        return cell
    }
}
