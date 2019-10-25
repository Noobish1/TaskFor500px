import Foundation

// MARK: HardCodedURL
public struct HardCodedURL {
    // MARK: properties
    public let url: URL

    // MARK: init
    public init(_ urlString: String) {
        guard let safeURL = URL(string: urlString) else {
            fatalError("urlString \(urlString) could not be turned into a URL")
        }

        self.url = safeURL
    }
}
