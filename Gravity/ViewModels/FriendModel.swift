import UIKit

/* Data to hold User Friends
   Associated with Friend Cells (Collection)
 */
struct FriendModel: CollectionCellRepresentable {
    var first: String
    var last: String
    var image: String
    
    var cellIdentifier: String {
        return "FriendCell"
    }
    
    func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            cellIdentifier, for: indexPath) as? FriendCell else {
            fatalError("Cell not found")
        }

        let image = UIImage(named: self.image)
        cell.profile.image = image
        cell.profile.setRounded()
        cell.name?.text = first
        
        return cell
    }
}

extension UIImageView {
    func setRounded() {
        self.layer.borderWidth = 0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
