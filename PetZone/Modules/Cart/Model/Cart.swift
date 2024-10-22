import Foundation
import ParseSwift

struct Cart: ParseObject, Codable, Equatable {
    var originalData: Data?

    init() {}

    var ACL: ParseSwift.ParseACL?
    var objectId: String?
    var name: String?
    var quantity: Int?
    var price: Double?
    var productId: Pointer<Product>?
    var iamgem: String?
    var createdAt: Date?
    var updatedAt: Date?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        productId = try container.decodeIfPresent(
            Pointer<Product>.self, forKey: .productId)
        iamgem = try container.decodeIfPresent(String.self, forKey: .iamgem)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(objectId, forKey: .objectId)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(quantity, forKey: .quantity)
        try container.encodeIfPresent(price, forKey: .price)
        try container.encodeIfPresent(productId, forKey: .productId)
        try container.encodeIfPresent(iamgem, forKey: .iamgem)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }

    private enum CodingKeys: String, CodingKey {
        case objectId
        case name
        case quantity
        case price
        case productId
        case iamgem
        case createdAt
        case updatedAt
    }

    static var parseClassName: String {
        return "Cart"
    }

    static func query() -> Query<Cart> {
        return Query<Cart>()
    }
}
