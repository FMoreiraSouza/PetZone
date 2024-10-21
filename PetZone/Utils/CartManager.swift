class CartManager {
    static let shared = CartManager()
    private init() {}

    var cartProducts: [Product] = []

    // Método para adicionar produtos ao carrinho
    func addProduct(_ product: Product) {
        if let index = cartProducts.firstIndex(where: { $0.id == product.id }) {
            // Se o produto já está no carrinho, incrementa a quantidade
            cartProducts[index].quantity = (cartProducts[index].quantity ?? 0) + 1
        } else {
            // Se o produto ainda não está no carrinho, adiciona-o
            var newProduct = product
            newProduct.quantity = 1
            cartProducts.append(newProduct)
        }
    }

    // Método para calcular o total
    func calculateTotal() -> Double {
        return cartProducts.reduce(0) { $0 + (($1.price ?? 0) * Double($1.quantity ?? 0)) }
    }
}
