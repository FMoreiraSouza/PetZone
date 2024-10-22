import Foundation
import ParseSwift

struct Product: ParseObject, Codable, Equatable {
    var originalData: Data?

    init() {}

    var ACL: ParseSwift.ParseACL?

    var objectId: String?
    var code: String?
    var name: String?
    var category: String?
    var description: String?
    var price: Double?
    var quantity: Int?
    var image: ParseFile?
    var expirationDate: Date?
    var createdAt: Date?
    var updatedAt: Date?

    struct Image: Codable, Equatable {
        var url: String?
        var name: String?

        init(url: String? = nil, name: String? = nil) {
            self.url = url
            self.name = name
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            url = try container.decodeIfPresent(String.self, forKey: .url)
            name = try container.decodeIfPresent(String.self, forKey: .name)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(url, forKey: .url)
            try container.encodeIfPresent(name, forKey: .name)
        }

        private enum CodingKeys: String, CodingKey {
            case url
            case name
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        code = try container.decodeIfPresent(String.self, forKey: .code)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        description = try container.decodeIfPresent(
            String.self, forKey: .description)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        image = try container.decodeIfPresent(ParseFile.self, forKey: .image)
        expirationDate = try container.decodeIfPresent(
            Date.self, forKey: .expirationDate)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(objectId, forKey: .objectId)
        try container.encodeIfPresent(code, forKey: .code)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(price, forKey: .price)
        try container.encodeIfPresent(quantity, forKey: .quantity)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encodeIfPresent(expirationDate, forKey: .expirationDate)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }

    private enum CodingKeys: String, CodingKey {
        case objectId
        case code
        case name
        case category
        case description
        case price
        case quantity
        case image
        case expirationDate
        case createdAt
        case updatedAt
    }

    static var parseClassName: String {
        return "Product"
    }

}
