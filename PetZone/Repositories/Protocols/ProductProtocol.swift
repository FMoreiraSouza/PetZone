protocol ProductProtocol {
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void)
}
