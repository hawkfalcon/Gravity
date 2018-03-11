import Foundation
import UIKit

/* View Model for Subscriptions
 Associated with Add Collection Cells
 */
struct AddSubscriptionViewModel: CollectionCellRepresentable {
    var subscription: Subscription
    
    init(subscription: Subscription) {
        self.subscription = subscription
    }
    
    var cellIdentifier: String {
        return "AddSubscriptionCell"
    }
    
    func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AddSubscriptionCell else {
                fatalError("Cell not found")
        }
        
        cell.configureWithModel(self)
        
        return cell
    }
}
