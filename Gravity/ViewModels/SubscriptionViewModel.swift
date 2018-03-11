import Foundation
import UIKit

/* View Model for Subscriptions
   Associated with Subscription Cells
 */
struct SubscriptionViewModel: TableCellRepresentable {
    var subscription: Subscription
    
    var friends: [FriendModel]
    
    var mainVC: SubscriptionsViewController?
    
    init(subscription: Subscription) {
        self.subscription = subscription
        
        self.friends = []
    }

    var cellIdentifier: String {
        return "SubscriptionCell"
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SubscriptionCell else {
            fatalError("Cell not found")
        }
        
        cell.configureWithModel(self)
        if let vc = mainVC {
            cell.delegate = vc
        }

        return cell
    }
}
