import Foundation
import ParseSwift

final class CartService: CartProtocol {
    func fetchCartItems(completion: @escaping (Result<[Cart], ParseError>) -> Void) {
        let query = Cart.query()
        query.find { result in
            switch result {
            case .success(let cartItems):
                completion(.success(cartItems))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addProductToCart(product: Product, completion: @escaping (Result<Void, ParseError>) -> Void) {
        var cart = Cart()
        cart.name = product.name
        cart.price = product.price
        cart.quantity = 1
        let productPointer = try? Pointer<Product>(objectId: product.objectId ?? "")
        cart.productId = productPointer
        
        cart.save { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProductQuantity(productId: String, completion: @escaping (Result<Void, ParseError>) -> Void) {
        let query = Cart.query()
        query.find { result in
            switch result {
            case .success(let results):
                if var existingCart = results.first(where: { $0.productId?.objectId == productId }) {
                    existingCart.quantity = (existingCart.quantity ?? 0) + 1
                    existingCart.save { saveResult in
                        switch saveResult {
                        case .success:
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    let error = ParseError(code: .objectNotFound, message: "Produto não encontrado no carrinho")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCartItem(productId: String, completion: @escaping (Result<Cart?, ParseError>) -> Void) {
        let query = Cart.query()
        query.find { result in
            switch result {
            case .success(let items):
                completion(.success(items.first(where: { $0.productId?.objectId == productId })))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
