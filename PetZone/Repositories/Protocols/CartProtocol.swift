import ParseSwift

protocol CartProtocol {
    func addProductToCart(product: Product, completion: @escaping (Result<Void, ParseError>) -> Void)
    func updateProductQuantity(productId: String, completion: @escaping (Result<Void, ParseError>) -> Void)
    func fetchCartItem(productId: String, completion: @escaping (Result<Cart?, ParseError>) -> Void)
    func fetchCartItems(completion: @escaping (Result<[Cart], ParseError>) -> Void)
}
