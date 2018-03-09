import UIKit
import DGCollectionViewLeftAlignFlowLayout
import Hero

private let reuseIdentifier = "Cell"

class AddSubscriptionCollectionViewController: UIViewController, UICollectionViewDelegate,
    UICollectionViewDataSource {
    
    @IBOutlet weak var suggestedSubscriptionsView: UICollectionView!
    @IBOutlet weak var allSubscriptionsView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        suggestedSubscriptionsView.tag = 0
        suggestedSubscriptionsView.delegate = self
        suggestedSubscriptionsView.dataSource = self
        
        allSubscriptionsView.tag = 1
        allSubscriptionsView.delegate = self
        allSubscriptionsView.dataSource = self
        
        allSubscriptionsView.collectionViewLayout = DGCollectionViewLeftAlignFlowLayout()
        suggestedSubscriptionsView.collectionViewLayout = DGCollectionViewLeftAlignFlowLayout()
        
//        configure(collectionView: suggestedSubscriptionsView)
//        configure(collectionView: allSubscriptionsView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? EditSubscriptionViewController, let sender = sender as? UICollectionViewCell else {
            print("Error loading EditSubscriptionViewController")
            return
        }
        destination.subscription = Subscription(id: 0, brand: Brand(name: "custom", icon: "custom", color: .black), cost: 0, type: "mo")
        guard let heroID = sender.hero.id else {
            print("Uh oh")
            return
        }
        destination.view.hero.modifiers = [.source(heroID: heroID)]
        destination.view.hero.id = heroID
        destination.view.hero.modifiers = [.durationMatchLongest]
        destination.hero.isEnabled = true
    }
    

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.hero.id = "selected\(indexPath.row)\(collectionView.tag)"
        cell.backgroundColor = UIColor.randomColor()
    
        // Configure the cell
    
        return cell
    }
    
//    // MARK: after user selected collection item
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//
//        let cell = collectionView.cellForItem(at: indexPath)
//
//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],
//                                   animations: {
//                                    cell!.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//
//        },
//        completion: { finished in
//            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseInOut,
//                 animations: {
//                    cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
//                 },
//           completion: nil)
//        }
//        )
//    }
    

    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension AddSubscriptionCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 2.0, bottom: 0.0, right: 2.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = UIScreen.main.bounds.width//collectionView.bounds.width
        let calculated = collectionViewWidth / 4.0 - 2.5
        return CGSize(width: calculated, height: calculated)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}

extension UIColor {
    
    class func randomColor() -> UIColor {
        
        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
