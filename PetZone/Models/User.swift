import Foundation
import ParseSwift

struct User: ParseUser, Codable {
    var emailVerified: Bool?
    var authData: [String: [String: String]?]?
    var originalData: Data?
    var objectId: String?
    var username: String?
    var email: String?
    var password: String?
    var name: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    init() {}
}
