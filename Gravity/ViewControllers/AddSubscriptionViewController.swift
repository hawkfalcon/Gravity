import UIKit
import DGCollectionViewLeftAlignFlowLayout
import Hero
import Firebase

private var tag = 0

class AddSubscriptionViewController: UIViewController, UICollectionViewDelegate,
    UICollectionViewDataSource {
    
    var mainVC: SubscriptionsViewController?
    
    @IBOutlet weak var suggestedSubscriptionsView: UICollectionView!
    @IBOutlet weak var allSubscriptionsView: UICollectionView!
    
    var addSubscriptionModels = [AddSubscriptionViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        configure(collectionView: suggestedSubscriptionsView)
        configure(collectionView: allSubscriptionsView)

        addSubscriptionModels.append(AddSubscriptionViewModel(subscription: Subscription(
            id: 0, brand: Brand(name: "Custom", icon: "none", color:
                UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)),
            cost: 0.0, type: "mo", date: Date())))
        
            loadData()
        
        super.viewDidLoad()
        
    }

    func configure(collectionView: UICollectionView) {
        collectionView.tag = tag
        tag += 1
        collectionView.delegate = self
        collectionView.dataSource = self
      
        collectionView.collectionViewLayout = DGCollectionViewLeftAlignFlowLayout()
    }
    
    func loadData() {
        // TODO fix this pile
        FIRDatabase.database().reference().child("subscriptions")
            .observeSingleEvent(of: .value, with: { (snapshot) in
            if let subscriptiondict = snapshot.value as? NSDictionary {
                for entry in subscriptiondict.allValues {
                    if let subscriptionvalue = entry as? NSDictionary {
                        self.addSubscriptionModels.append(
                            AddSubscriptionViewModel(subscription:
                                self.createSubscription(subscriptionvalue: subscriptionvalue)
                        ))
                    }
                }
                
                self.suggestedSubscriptionsView.reloadData()
                    //self.allSubscriptionsView.reloadData()
                
            } else {
                fatalError("No snapshot values :(")
            }
        }, withCancel: { error in
            print(error.localizedDescription)
        })
    }
    
    func createSubscription(subscriptionvalue: NSDictionary) -> Subscription {
        return Subscription(id: 0,
            brand: Brand(
                name: subscriptionvalue["name"] as? String ?? "COMPANY NAME",
                icon: subscriptionvalue["icon"] as? String ?? "ICON",
                color: UIColor(
                    red: subscriptionvalue["r"] as? CGFloat ?? 1.0,
                    green: subscriptionvalue["g"] as? CGFloat ?? 1.0,
                    blue: subscriptionvalue["b"] as? CGFloat ?? 1.0
                )
            ),
            cost: subscriptionvalue["cost"] as? Float ?? -1.0,
            type: subscriptionvalue["type"] as? String ?? "TYPE",
            date: Date()
        )
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? EditSubscriptionViewController, let sender = sender as? UICollectionViewCell else {
            print("Error loading EditSubscriptionViewController")
            return
        }
        
        destination.mainVC = mainVC
        // TODO: support both collectionviews
        if let index = suggestedSubscriptionsView.indexPath(for: sender) {
            destination.subscription = addSubscriptionModels[index.row].subscription
        }
        
        guard let heroID = sender.hero.id else {
            print("Sender has no id")
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
        return addSubscriptionModels.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = addSubscriptionModels[indexPath.row]
        let cell = model.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        
        cell.hero.id = "selected\(indexPath.row)\(collectionView.tag)"
        
        return cell
    }
}

extension AddSubscriptionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let calculated = collectionViewWidth / 4.0 - 6.0
        return CGSize(width: calculated, height: calculated)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}
