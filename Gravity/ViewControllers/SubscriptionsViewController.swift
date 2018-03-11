import UIKit
import SwipeCellKit
import Hero

class SubscriptionsViewController: UITableViewController {
    
    var subscriptionModels = [
        SubscriptionViewModel(subscription: Subscription(id: 0, brand:
            Brand(name: "Netflix", icon: "netflix", color:
                UIColor(red: 185, green: 9, blue: 11)),
            cost: 9.99, type: "mo", date: Date())),
        SubscriptionViewModel(subscription: Subscription(id: 1, brand:
            Brand(name: "Spotify", icon: "spotify", color:
                UIColor(red: 30, green: 215, blue: 96)),
            cost: 4.99, type: "mo", date: Date()))
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
        
        navigationController?.hero.isEnabled = true
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 115
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTotal()
        tableView.reloadData()
    }
    
    func setTotal() {
        total.title = "Total: $\(calculateTotal())/mo"
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptionModels.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SubscriptionCell {
            UIView.animate(withDuration: 0.3) {
                cell.friends.isHidden = !cell.friends.isHidden
                cell.expandedFriends.isHidden = !cell.expandedFriends.isHidden
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SubscriptionCell else {
            fatalError("Cell not found")
        }
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
   
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
        return 1
    }
    
    // Dequeue cells using TableViewSource compliant models
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var subscription = subscriptionModels[indexPath.row]
        subscription.mainVC = self
        
        return subscription.cellForTableView(tableView: tableView, atIndexPath: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension SubscriptionsViewController {
    // Set up size and footer

    /* We now set this dynamically
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    }*/
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
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
        
        return friend.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
    }
}

extension SubscriptionsViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath,
        for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let delete = SwipeAction(style: .destructive, title: "Delete") { _, indexPath in
            self.subscriptionModels.remove(at: indexPath.row)
            self.setTotal()
        }
        
        let edit = SwipeAction(style: .default, title: "Edit") { _, indexPath in
            // TODO: edit
        }
        edit.hidesWhenSelected = true
        
        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath:
        IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        
        return options
    }
}

extension Float {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
}
