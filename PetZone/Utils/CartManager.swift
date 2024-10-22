class CartManager {
    static let shared = CartManager()
    private init() {}

    var cartProducts: [Product] = []

    func addProduct(_ product: Product) {
        if let index = cartProducts.firstIndex(where: { $0.id == product.id }) {
            cartProducts[index].quantity =
                (cartProducts[index].quantity ?? 0) + 1
        } else {
            var newProduct = product
            newProduct.quantity = 1
            cartProducts.append(newProduct)
        }
    }

    func calculateTotal() -> Double {
        return cartProducts.reduce(0) {
            $0 + (($1.price ?? 0) * Double($1.quantity ?? 0))
        }
    }
}
