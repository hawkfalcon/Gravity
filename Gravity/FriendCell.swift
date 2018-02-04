import UIKit

class FriendCell: UICollectionViewCell {
    @IBOutlet weak var profile: UIImageView!
}

extension UIImageView {
    func setRounded() {
        self.layer.borderWidth = 0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}
