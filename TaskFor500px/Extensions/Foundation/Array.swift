import Foundation

// MARK: General extensions
extension Array {
    // MARK: safe subscripting
    internal subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}
