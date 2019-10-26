import Foundation

// MARK: General extensions
extension Array {
    // MARK: safe subscripting
    public subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}
