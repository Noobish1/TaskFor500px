import Foundation
import Tagged

internal enum PercentageTag {}

internal typealias Percentage<A> = Tagged<PercentageTag, A>

extension Int {
    internal var percent: Percentage<CGFloat> {
        return Percentage(rawValue: CGFloat(self) / 100)
    }
}
