import UIKit
import Hero

class EditSubscriptionViewController: UITableViewController {

    var subscription: Subscription!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var frequency: UITextField!
    
    var mainVC: SubscriptionsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = subscription.brand.name
        icon.image = subscription.brand.icon
        date.text = "02/04/2018"
        price.text = "\(subscription.cost.currency)"
        frequency.text = subscription.type
        price.delegate = self
    }
    
    @IBAction func done(_ sender: Any) {
        //subscription.brand.name = name.text
        //subscription.date = Date()//date.text
        if let cost = price.text?.rawFloat {
            subscription.cost = cost
        }
        if let type = frequency.text {
            subscription.type = type
        }
        mainVC?.subscriptionModels.append(SubscriptionViewModel(subscription: subscription))
        
        icon.hero.id = subscription.brand.name
        print("DONE")
        hero.unwindToViewController(mainVC!)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }
}

extension EditSubscriptionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let money = textField.text?.rawFloat {
            textField.text = money.currency
        }
    }
}

extension Float {
    var currency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self))!
    }
}

extension String {
    var rawFloat: Float? {
        var raw = self.replacingOccurrences(of: "$", with: "")
        raw = raw.replacingOccurrences(of: ",", with: "")
        return Float(raw)
    }
}
