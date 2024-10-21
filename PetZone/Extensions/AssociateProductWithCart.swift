import Foundation
import ParseSwift

extension Cart {
    init(from product: Product, quantity: Int) {
        self.objectId = product.objectId
        self.name = product.name
        self.quantity = quantity
        self.price = product.price
        self.createdAt = Date()  // ou outra data relevante
        self.updatedAt = Date()  // ou outra data relevante
    }
}

extension Product {
    static func createPointer(objectId: String) -> Pointer<Product> {
        return Pointer<Product>(objectId: objectId)
    }
}
