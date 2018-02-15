import Foundation
import UIKit

/* Data to hold User Subscriptions
   Associated with Subscription Cells
 */
struct UserSubscriptionModel: TableViewSource {
    var name: String
    var icon: String
    var color: UIColor
    var cost: Float
    var type: String
    
    var friends: [FriendModel]
    
    var current: Bool
    
    init(name: String, icon: String, color: UIColor, cost: Float, type: String) {
        self.name = name
        self.icon = icon
        self.color = color
        self.cost = cost
        self.type = type
        
        friends = []
        current = false
    }
    
    var cellIdentifier: String {
        return "SubscriptionCell"
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SubscriptionCell else {
            fatalError("Cell not found")
        }
        
        cell.name.text = self.name
        cell.icon.image = UIImage(named: self.name.lowercased().replacingOccurrences(of: " ", with: ""))
        cell.cost.text = "$\(self.cost)"
        cell.type.text = "/\(self.type)"
        cell.colorBar.backgroundColor = color
        cell.colorBar.frame.size.width /= 1.5
        
        cell.header.backgroundColor = .clear
        cell.footer.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)

        return cell
    }
}
