import UIKit

struct Brand {
    let name: String
    let icon: UIImage
    let color: UIColor
    
    init(name: String, icon: String, color: UIColor) {
        self.name = name
        self.color = color
        self.icon = UIImage(named: name.lowercased().replacingOccurrences(of: " ", with: ""))!
    }
}
