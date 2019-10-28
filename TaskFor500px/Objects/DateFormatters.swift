import Foundation

internal enum DateFormatters {
    internal static let iso8601 = ISO8601DateFormatter().then {
        $0.formatOptions = [.withInternetDateTime]
    }
    internal static let relative = RelativeDateTimeFormatter()
}
