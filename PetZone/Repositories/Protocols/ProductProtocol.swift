import ParseSwift

protocol ProductProtocol {
    func fetchProducts(completion: @escaping (Result<[Product], ParseError>) -> Void)
}
