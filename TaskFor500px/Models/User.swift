import Foundation

internal struct User: Codable {
    internal enum CodingKeys: String, CodingKey {
        case fullName = "fullname"
        case avatarURL = "userpic_https_url"
    }
    
    internal let fullName: String
    internal let avatarURL: URL
}
