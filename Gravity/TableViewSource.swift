import UIKit
protocol TableViewSource {

    var cellIdentifier: String { get }
        
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell
    
}
