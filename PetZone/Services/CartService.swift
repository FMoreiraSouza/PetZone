import ParseSwift

class CartService {

    func saveProductToCart(
        name: String, price: Double, quantity: Int32, productId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        var cart = Cart()

        cart.name = name
        cart.price = price
        cart.quantity = Int(quantity)
        cart.productId = Pointer<Product>(objectId: productId)

        cart.save { result in
            switch result {
            case .success:
                print("Produto salvo com sucesso no Back4App!")

                self.fetchCartItem(productId: productId) { fetchResult in
                    switch fetchResult {
                    case .success(let cartItem):
                        if let cartItem = cartItem {
                            print("Dados do carrinho após salvar:")
                            print("Nome: \(cartItem.name ?? "N/A")")
                            print("Preço: \(cartItem.price)")
                            print("Quantidade: \(cartItem.quantity ?? 0)")
                            print(
                                "ID do produto: \(cartItem.productId?.objectId ?? "N/A")"
                            )
                        } else {
                            print("Nenhum item encontrado no carrinho.")
                        }
                    case .failure(let error):
                        print(
                            "Falha ao buscar item do carrinho: \(error.localizedDescription)"
                        )
                    }
                }

                completion(.success(()))
            case .failure(let error):
                print(
                    "Falha ao salvar o produto: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func fetchCartItems(completion: @escaping (Result<[Cart], Error>) -> Void) {
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

    func fetchCartItem(
        productId: String, completion: @escaping (Result<Cart?, Error>) -> Void
    ) {
        let query = Cart.query

        query.find { result in
            switch result {
            case .success(let items):
                if let cartItem = items.first {
                    print("Item encontrado: \(cartItem)")
                    completion(.success(cartItem))
                } else {
                    print(
                        "Nenhum item encontrado com o productId: \(productId)")
                    completion(.success(nil))
                }
            case .failure(let error):
                print(
                    "Falha ao buscar item do carrinho: \(error.localizedDescription)"
                )
                completion(.failure(error))
            }
        }
    }
    func updateCartItem(
        cartItem: Cart, completion: @escaping (Result<Void, Error>) -> Void
    ) {
        cartItem.save { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
