import Foundation
import ParseSwift

final class ProductService: ProductProtocol {
    func fetchProducts(completion: @escaping (Result<[Product], ParseError>) -> Void) {
        let query = Product.query()
        query.find { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
