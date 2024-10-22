import Foundation
import ParseSwift

extension Cart {
    init(from product: Product, quantity: Int) {
        self.objectId = product.objectId
        self.name = product.name
        self.quantity = quantity
        self.price = product.price
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

extension Product {
    static func createPointer(objectId: String) -> Pointer<Product> {
        return Pointer<Product>(objectId: objectId)
    }
}
