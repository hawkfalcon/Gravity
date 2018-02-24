import UIKit
import FirebaseDatabase

class AddSubscriptionViewController: UITableViewController {
    var addSubscriptionModels = [AddSubscriptionViewModel]()
    
    var mainVC: SubscriptionsViewController?

    override func viewDidLoad() {
            // TODO fix this pile
        FIRDatabase.database().reference().child("subscriptions").observeSingleEvent(of: .value, with: { (snapshot) in
            if let subscriptiondict = snapshot.value as? NSDictionary {
                for entry in subscriptiondict.allValues {
                    if let subscriptionvalue = entry as? NSDictionary {
                        self.addSubscriptionModels.append(
                            AddSubscriptionViewModel(subscription: Subscription(id: 0,
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
                                type: subscriptionvalue["type"] as? String ?? "TYPE"
                            )
                        ))
                    }
                }
                
                self.tableView.reloadData()
                
            } else {
                fatalError("No snapshot values :(")
            }
        }, withCancel: { error in
            print(error.localizedDescription)
            
        }
        )
        addSubscriptionModels.append(AddSubscriptionViewModel(subscription: Subscription(
            id: 0, brand: Brand(name: "Custom", icon: "none", color:
            UIColor(red: 150, green: 150, blue: 10, alpha: 1.0)),
            cost: 0.0, type: "mo")))

        super.viewDidLoad()
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "subSegue" {
            guard let destination = segue.destination as? EditSubscriptionViewController else {
                print("Error loading EditSubscriptionViewController")
                return
            }
            destination.mainVC = mainVC
            if let index = tableView.indexPathForSelectedRow?.section {
                destination.subscription = addSubscriptionModels[index].subscription
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension AddSubscriptionViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return addSubscriptionModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultSubscription = addSubscriptionModels[indexPath.section]
        
        return defaultSubscription.cellForTableView(tableView: tableView, atIndexPath: indexPath)
    }

}

// MARK: - UITableViewDelegate
extension AddSubscriptionViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
}

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
}
