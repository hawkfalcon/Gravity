//
//  AddViewController.swift
//  Gravity
//
//  Created by Tristen Miller on 2/3/18.
//  Copyright © 2018 SLOHacks. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddViewController: UITableViewController {
    var subscriptionDefaults = [Subscription]()
    
    var mainVC: TableViewController?

    let cellIdentifier = "AddCell"

    override func viewDidLoad() {
    
        FIRDatabase.database().reference().child("subscriptions").observeSingleEvent(of: .value, with: { (snapshot) in
            if let subscriptiondict = snapshot.value as? NSDictionary {
                for entry in subscriptiondict.allValues {
                    if let subscriptionvalue = entry as? NSDictionary{
                        self.subscriptionDefaults.append(
                            Subscription(
                                name: subscriptionvalue["name"] as? String ?? "COMPANY NAME",
                                icon: subscriptionvalue["icon"] as? String ?? "ICON",
                                color: Color(
                                    r: subscriptionvalue["r"] as! CGFloat,
                                    g: subscriptionvalue["g"] as! CGFloat,
                                    b: subscriptionvalue["b"] as! CGFloat
                                    ).uiColor(),
                                cost: subscriptionvalue["cost"] as? Float ?? -1.0,
                                type: subscriptionvalue["type"] as? String ?? "TYPE"))
                    }
                    
                }
                
                self.tableView.reloadData()
                
            }
            else {
                fatalError("No snapshot values :(")
            }
        }, withCancel: { error in
            print(error.localizedDescription)
            
        }
        )
        subscriptionDefaults.append(Subscription(name: "Custom", icon: "none", color: Color(r: 100, g: 100, b: 100).uiColor(), cost: 0.0, type: "mo"))

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
        if (segue.identifier == "subSegue") {
            let destination = segue.destination as! SubscriptionViewController
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
