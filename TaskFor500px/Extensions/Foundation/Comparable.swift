import Foundation

// MARK: General
extension Comparable {
    internal func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
