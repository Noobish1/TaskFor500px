import Foundation

extension ClosedRange where Bound == CGFloat {
    internal func widen(byAmount amount: CGFloat) -> ClosedRange<Bound> {
        return (lowerBound - abs(amount))...(upperBound + abs(amount))
    }
    
    internal func widen(byPercentage percentage: Percentage<Bound>) -> ClosedRange<Bound> {
        // This works with negative and positive numbers
        let widerLowerBound = (lowerBound - (abs(lowerBound) * percentage.rawValue))
        let widerUpperBound = (upperBound + (abs(upperBound) * percentage.rawValue))
        
        return widerLowerBound...widerUpperBound
    }
}
