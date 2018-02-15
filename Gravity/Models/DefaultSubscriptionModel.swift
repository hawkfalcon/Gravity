import Foundation
import UIKit

/* Data for Default Subscriptions
   Associated with Add Cells (TODO)
 */
struct DefaultSubscriptionModel: TableViewSource {
    var name: String
    var icon: String
    var color: UIColor
    var cost: Float
    var type: String
    
    var cellIdentifier: String {
        return "SubscriptionCellIdentifier"
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SubscriptionCell else {
            fatalError("Cell not found")
        }
        
        cell.name.text = self.name
        cell.icon.image = UIImage(named: self.name.lowercased().replacingOccurrences(of: " ", with: ""))
        cell.cost.text = "$\(self.cost)"
        cell.type.text = "/\(self.type)"
        
        return cell
    }
}
