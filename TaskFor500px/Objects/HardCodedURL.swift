import Foundation

// MARK: HardCodedURL
internal struct HardCodedURL {
    // MARK: properties
    internal let url: URL

    // MARK: init
    // This uses a StaticString so it cannot be passed strings containing string interpolation
    // Got the idea from: https://www.swiftbysundell.com/tips/defining-static-urls-using-string-literals/
    internal init(_ urlString: StaticString) {
        guard let safeURL = URL(string: "\(urlString)") else {
            fatalError("urlString \(urlString) could not be turned into a URL")
        }

        self.url = safeURL
    }
}
