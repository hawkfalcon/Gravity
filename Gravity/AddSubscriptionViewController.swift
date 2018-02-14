//
//  AddViewController.swift
//  Gravity
//
//  Created by Tristen Miller on 2/3/18.
//  Copyright © 2018 SLOHacks. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddSubscriptionViewController: UITableViewController {
    var subscriptionDefaults = [UserSubscriptionModel]()
    
    var mainVC: SubscriptionsViewController?

    let cellIdentifier = "AddCell"

    override func viewDidLoad() {
        FIRDatabase.database().reference().child("subscriptions").observeSingleEvent(of: .value, with: { (snapshot) in
            if let subscriptiondict = snapshot.value as? NSDictionary {
                for entry in subscriptiondict.allValues {
                    if let subscriptionvalue = entry as? NSDictionary {
                        self.subscriptionDefaults.append(
                            UserSubscriptionModel(
                                name: subscriptionvalue["name"] as? String ?? "COMPANY NAME",
                                icon: subscriptionvalue["icon"] as? String ?? "ICON",
                                color: UIColor(
                                    red: subscriptionvalue["r"] as? CGFloat ?? 1.0,
                                    green: subscriptionvalue["g"] as? CGFloat ?? 1.0,
                                    blue: subscriptionvalue["b"] as? CGFloat ?? 1.0
                                ),
                                cost: subscriptionvalue["cost"] as? Float ?? -1.0,
                                type: subscriptionvalue["type"] as? String ?? "TYPE"
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
        subscriptionDefaults.append(UserSubscriptionModel(name: "Custom", icon: "none", color:
            UIColor(red: 100, green: 100, blue: 100, alpha: 1.0), cost: 0.0, type: "mo"))

        super.viewDidLoad()
    
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return subscriptionDefaults.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "subSegue", sender: subscriptionDefaults[indexPath.section])
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "subSegue" {
            guard let destination = segue.destination as? EditSubscriptionViewController else {
                print("Error loading SubscriptionViewController")
                return
            }
            destination.mainVC = mainVC
            if let index = tableView.indexPathForSelectedRow?.section {
                destination.subscription = subscriptionDefaults[index]
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AddCell else {
            fatalError("Cell not found")
        }
        
        let sub = subscriptionDefaults[indexPath.section]
        cell.name.text = sub.name
        cell.icon.image = UIImage(named: sub.name.lowercased().replacingOccurrences(of: " ", with: ""))
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = sub.color.cgColor
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true

        return cell
    }

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
