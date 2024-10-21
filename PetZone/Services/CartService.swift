import ParseSwift
class CartService {

    func saveProductToCart(
        name: String, price: Double, quantity: Int32, productId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        var cart = Cart()  // Instanciando um novo objeto Cart

        // Atribuindo valores ao objeto Cart
        cart.name = name
        cart.price = price
        cart.quantity = Int(quantity)  // Convertendo Int32 para Int
        cart.productId = Pointer<Product>(objectId: productId)  // Criando um ponteiro a partir do productId

        // Salvar o produto no Back4App
        cart.save { result in
            switch result {
            case .success:
                print("Produto salvo com sucesso no Back4App!")
                
                // Chama o método fetchCartItem para imprimir os dados
                self.fetchCartItem(productId: productId) { fetchResult in
                    switch fetchResult {
                    case .success(let cartItem):
                        if let cartItem = cartItem {
                            print("Dados do carrinho após salvar:")
                            print("Nome: \(cartItem.name ?? "N/A")")
                            print("Preço: \(cartItem.price)")
                            print("Quantidade: \(cartItem.quantity ?? 0)")
                            print("ID do produto: \(cartItem.productId?.objectId ?? "N/A")")
                        } else {
                            print("Nenhum item encontrado no carrinho.")
                        }
                    case .failure(let error):
                        print("Falha ao buscar item do carrinho: \(error.localizedDescription)")
                    }
                }

                completion(.success(()))
            case .failure(let error):
                print("Falha ao salvar o produto: \(error.localizedDescription)")
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
        
        // Executando a consulta
        query.find { result in
            switch result {
            case .success(let items):
                if let cartItem = items.first {
                    print("Item encontrado: \(cartItem)")
                    completion(.success(cartItem))
                } else {
                    print("Nenhum item encontrado com o productId: \(productId)")
                    completion(.success(nil))
                }
            case .failure(let error):
                print("Falha ao buscar item do carrinho: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    func updateCartItem(cartItem: Cart, completion: @escaping (Result<Void, Error>) -> Void) {
          // Aqui, você deve implementar a lógica para atualizar o item no banco de dados.
          // Exemplo:
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
