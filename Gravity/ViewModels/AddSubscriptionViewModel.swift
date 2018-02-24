import Foundation
import UIKit

/* View Model for BaseSubscriptions
   Associated with Add Cells
 */
struct AddSubscriptionViewModel: TableCellRepresentable {
    var subscription: Subscription
    
    init(subscription: Subscription) {
        self.subscription = subscription
    }
    
    var cellIdentifier: String {
        return "AddSubscriptionCell"
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
            for: indexPath) as? AddSubscriptionCell else {
            fatalError("Cell not found")
        }
        
        cell.configureWithModel(self)
        
        return cell
    }
}
