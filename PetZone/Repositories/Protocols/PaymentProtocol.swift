protocol PaymentProtocol {
    func clearCart(completion: @escaping (Bool) -> Void)
    func updateProductQuantity(productId: String, newQuantity: Int, completion: @escaping (Bool) -> Void)
}
