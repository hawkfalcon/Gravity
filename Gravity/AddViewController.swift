//
//  AddViewController.swift
//  Gravity
//
//  Created by Tristen Miller on 2/3/18.
//  Copyright © 2018 SLOHacks. All rights reserved.
//

import UIKit

class AddViewController: UITableViewController {
    let subscriptionDefaults = [
        Subscription(name: "Netflix", icon: "netflix", color: Color(r: 185, g: 9, b: 11).uiColor(), cost: 10.0, type: "mo"),
        Subscription(name: "Spotify", icon: "spotify", color: Color(r: 30, g: 215, b: 96).uiColor(), cost: 12.0, type: "mo")
    ]
    let cellIdentifier = "AddCell"

    override func viewDidLoad() {
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
        cell.icon.image = UIImage(named: sub.icon)
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
