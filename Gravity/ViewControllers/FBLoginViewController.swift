import UIKit

class FBLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func test(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
