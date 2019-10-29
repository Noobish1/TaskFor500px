import UIKit

// MARK: General extensions
extension UIColor {
    // MARK: Adjusting methods
    // adapted from https://stackoverflow.com/a/38435309
    internal func lighter(by percentage: Percentage<CGFloat>) -> UIColor {
        return self.adjust(by: abs(percentage.rawValue))
    }

    internal func darker(by percentage: Percentage<CGFloat>) -> UIColor {
        return self.adjust(by: -1 * abs(percentage.rawValue))
    }

    internal func adjust(by percentage: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            fatalError("Could got get colors from image: \(self)")
        }

        return UIColor(red: min(red + percentage, 1.0),
                       green: min(green + percentage, 1.0),
                       blue: min(blue + percentage, 1.0),
                       alpha: alpha)
    }
}
