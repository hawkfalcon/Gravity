import Foundation
import UIKit

/* Data for Default Subscriptions
   Associated with Add Cells
 */
struct DefaultSubscriptionModel: TableViewSource {
    var name: String
    var icon: String
    var color: UIColor
    var cost: Float
    var type: String
    
    var cellIdentifier: String {
        return "AddCell"
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AddCell else {
            fatalError("Cell not found")
        }
        
        cell.name.text = self.name
        cell.icon.image = UIImage(named: self.name.lowercased().replacingOccurrences(of: " ", with: ""))
        cell.layer.borderColor = self.color.cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        return cell
    }
}
