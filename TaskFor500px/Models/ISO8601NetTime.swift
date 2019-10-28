import Foundation
import Tagged

internal enum ISO8601NetTimeTag {}

internal typealias ISO8601NetTime<A> = Tagged<ISO8601NetTimeTag, A>

extension Tagged where Tag == ISO8601NetTimeTag, RawValue == String {
    internal var date: Date {
        let formatter = DateFormatters.iso8601

        guard let date = formatter.date(from: rawValue) else {
            fatalError("Could not convert \(rawValue) to a Date")
        }

        return date
    }
}
