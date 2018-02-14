import UIKit

struct FriendModel: CollectionViewSource {
    var first: String
    var last: String
    var image: String
    
    var cellIdentifier: String {
        return "ExpandedFriendCell"
    }
    
    func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            cellIdentifier, for: indexPath) as? ExpandedFriendCell else {
            fatalError("Cell not found")
        }

        let image = UIImage(named: self.image)
        cell.profile.image = image
        cell.profile.setRounded()
        cell.name.text = first
        
        return cell
    }
}
