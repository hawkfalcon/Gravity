import UIKit

struct UserFriendsModel: TableViewSource {
    var friends: [FriendModel]
        
    var cellIdentifier: String {
        return "ExpandedSubscriptionCell"
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
            for: indexPath) as? ExpandedSubscriptionCell else {
            fatalError("Cell not found")
        }
               
        return cell
    }
}
