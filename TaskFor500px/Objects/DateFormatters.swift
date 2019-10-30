import Foundation

// I use this to cache dateformatters because they are expensive to create
// I use an enum because it cannot be initialised
internal enum DateFormatters {
    internal static let iso8601 = ISO8601DateFormatter().then {
        $0.formatOptions = [.withInternetDateTime]
    }
    internal static let relative = RelativeDateTimeFormatter()
}
