import Foundation
import ParseSwift

final class PaymentService: PaymentProtocol {
    func clearCart(completion: @escaping (Bool) -> Void) {
        let query = Cart.query()
        
        query.find { result in
            switch result {
            case .success(let cartItems):
                let dispatchGroup = DispatchGroup()
                var success = true
                for cartItem in cartItems {
                    dispatchGroup.enter()
                    cartItem.delete { result in
                        switch result {
                        case .success:
                            break
                        case .failure(let error):
                            print("Erro ao remover item do carro de compras: \(error.localizedDescription)")
                            success = false
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(success)
                }
                
            case .failure(let error):
                print("Erro ao buscar os itens do carro de compras: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func updateProductQuantity(productId: String, newQuantity: Int, completion: @escaping (Bool) -> Void) {
        let query = Product.query("objectId" == productId)
        
        query.first { result in
            switch result {
            case .success(var product):
                product.quantity = newQuantity                
                product.save { saveResult in
                    switch saveResult {
                    case .success:
                        print("Quantidade do produto \(productId) atualizada para \(newQuantity).")
                        completion(true)
                    case .failure(let error):
                        print("Falha ao atualizar a quantidade do produto: \(error.localizedDescription)")
                        completion(false)
                    }
                }
                
            case .failure(let error):
                print("Falha ao buscar o produto no Back4App: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
