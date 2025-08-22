import Foundation
import ParseSwift

final class CartService: CartProtocol {
    
    func fetchCartItems(completion: @escaping (Result<[Cart], Error>) -> Void) {
        let query = Cart.query()
        query.find { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cartItems):
                    completion(.success(cartItems))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func addProductToCart(product: Product, completion: @escaping (Result<Void, Error>) -> Void) {
        var cart = Cart()
        cart.name = product.name
        cart.price = product.price
        cart.quantity = 1
        
        if let objectId = product.objectId {
            cart.productId = Pointer<Product>(objectId: objectId)
        }
        
        cart.save { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updateProductQuantity(productId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let query = Cart.query()
        query.find { result in
            switch result {
            case .success(let results):
                if var existingCart = results.first(where: { $0.productId?.objectId == productId }) {
                    existingCart.quantity = (existingCart.quantity ?? 0) + 1
                    existingCart.save { saveResult in
                        DispatchQueue.main.async {
                            switch saveResult {
                            case .success:
                                completion(.success(()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                } else {
                    let error = NSError(domain: "CartService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Produto não encontrado no carrinho"])
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchCartItem(productId: String, completion: @escaping (Result<Cart?, Error>) -> Void) {
        let query = Cart.query()
        query.find { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    let cartItem = items.first(where: { $0.productId?.objectId == productId })
                    completion(.success(cartItem))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
