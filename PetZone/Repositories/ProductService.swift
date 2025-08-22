import Foundation
import ParseSwift

final class ProductService: ProductProtocol {
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        let query = Product.query()
        query.find { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    completion(.success(products))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
