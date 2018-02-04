import UIKit

struct Color {
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
    
    func uiColor() -> UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}
