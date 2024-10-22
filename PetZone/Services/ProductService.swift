import Foundation
import ParseSwift

class ProductService {

    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void)
    {
        let query = Product.query()

        query.find { result in
            switch result {
            case .success(let products):
                completion(.success(products))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
