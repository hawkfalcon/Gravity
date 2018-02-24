import UIKit

protocol CollectionCellRepresentable {
    
    var cellIdentifier: String { get }
    
    func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> UICollectionViewCell
}
