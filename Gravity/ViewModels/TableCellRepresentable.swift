import UIKit

protocol TableCellRepresentable {
    var cellIdentifier: String { get }
        
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell
    
}
