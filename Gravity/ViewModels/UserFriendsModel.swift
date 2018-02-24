import UIKit

/* Data to hold User Friends
   Associated with ExpandedSubscription Cells (Table)
 */
struct UserFriendsModel: TableCellRepresentable {
    var friends: [FriendModel]
        
    var cellIdentifier: String {
        return "ExpandedSubscriptionCell"
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
            for: indexPath) as? ExpandedSubscriptionCell else {
            fatalError("Cell not found")
        }
        
        cell.footer.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)

        return cell
    }
}
