protocol CartProtocol {
    func addProductToCart(product: Product, completion: @escaping (Result<Void, Error>) -> Void)
    func updateProductQuantity(productId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchCartItem(productId: String, completion: @escaping (Result<Cart?, Error>) -> Void)
    func fetchCartItems(completion: @escaping (Result<[Cart], Error>) -> Void)
}
