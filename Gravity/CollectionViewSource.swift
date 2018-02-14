import UIKit
protocol CollectionViewSource {
    
    var cellIdentifier: String { get }
    
    func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> UICollectionViewCell
}
