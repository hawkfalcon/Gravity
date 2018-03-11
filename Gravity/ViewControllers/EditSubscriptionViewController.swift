import UIKit
import Hero
import DateTimePicker

class EditSubscriptionViewController: UITableViewController {

    var subscription: Subscription!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var frequency: UITextField!
    
    var dateSelected: Date!
    
    var mainVC: SubscriptionsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = subscription.brand.name
        icon.image = subscription.brand.icon
        price.text = "\(subscription.cost.currency)"
        frequency.text = subscription.type
        
        dateSelected = subscription.date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        self.date.text = formatter.string(from: dateSelected)
        
        price.delegate = self
    }
    
    @IBAction func done(_ sender: Any) {
        //subscription.brand.name = name.text
        subscription.date = dateSelected
        if let cost = price.text?.rawFloat {
            subscription.cost = cost
        }
        if let type = frequency.text {
            subscription.type = type
        }
        mainVC?.subscriptionModels.append(SubscriptionViewModel(subscription: subscription))
        
        icon.hero.id = subscription.brand.name
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
        if let dateCell = tableView.cellForRow(at: indexPath), dateCell.reuseIdentifier == "date" {
            showDatePicker()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }
}

extension EditSubscriptionViewController: DateTimePickerDelegate {
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        self.date.text = picker.selectedDateString
    }
    
    func showDatePicker() {
        let min = Calendar.current.previousMonth(months: 2).startOfMonth()
        let max = Calendar.current.nextMonth(months: 2).endOfMonth()
        let picker = DateTimePicker.show(selected: dateSelected, minimumDate: min, maximumDate: max)
        picker.highlightColor = subscription.brand.color
        picker.includeMonth = true
        picker.dateFormat = "MM/dd/YYYY"
        picker.isDatePickerOnly = true
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/YYYY"
            self.date.text = formatter.string(from: date)
            self.dateSelected = date
        }
        picker.delegate = self
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

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

extension Calendar {
    func previousMonth(months: Int) -> Date {
        return self.date(byAdding: .month, value: months * -1, to: Date())!
    }
    
    func nextMonth(months: Int) -> Date {
        return self.date(byAdding: .month, value: months, to: Date())!
    }
}
