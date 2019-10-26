import Foundation

// MARK: HardCodedURL
internal struct HardCodedURL {
    // MARK: properties
    internal let url: URL

    // MARK: init
    internal init(_ urlString: String) {
        guard let safeURL = URL(string: urlString) else {
            fatalError("urlString \(urlString) could not be turned into a URL")
        }

        self.url = safeURL
    }
}
