import UIKit

final class CartController: UIViewController {
    
    var products: [Product] = []
    var cartProducts: [Cart] = []
    private let cartService = CartService()
    private lazy var cartView = CartView()
    
    override func loadView() {
        view = cartView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActions()
        fetchCartItems()
    }
    
    private func setupTableView() {
        cartView.tableView.register(
            CartTableCell.self, 
            forCellReuseIdentifier: CartTableCell.identifier
        )
        cartView.tableView.dataSource = self
    }
    
    private func setupActions() {
        cartView.paymentButton.addTarget(
            self, 
            action: #selector(goToPayment), 
            for: .touchUpInside
        )
    }
    
    private func fetchCartItems() {
        cartService.fetchCartItems { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cartItems):
                    self?.cartProducts = cartItems
                    self?.cartView.tableView.reloadData()
                    self?.updateTotalLabel()
                case .failure(let error):
                    print("Erro ao buscar itens do carrinho: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func calculateTotal() -> Double {
        var total: Double = 0.0
        for product in cartProducts {
            if let price = product.price, let quantity = product.quantity {
                total += price * Double(quantity)
            }
        }
        return total
    }
    
    private func updateTotalLabel() {
        let total = calculateTotal()
        cartView.totalLabel.text = String(format: "Total: $%.2f", total)
    }
    
    @objc private func goToPayment() {
        let paymentVC = PaymentController()
        paymentVC.totalAmount = calculateTotal()
        paymentVC.products = products
        paymentVC.cartProducts = cartProducts
        navigationController?.pushViewController(paymentVC, animated: true)
    }
}

extension CartController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.isEmpty ? 1 : cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableCell.identifier, 
            for: indexPath
        ) as! CartTableCell

        if cartProducts.isEmpty {
            cell.configure(with: "Nenhum produto adicionado.")
        } else {
            let product = cartProducts[indexPath.row]
            let priceText = product.price != nil ? 
                String(format: "$%.2f", product.price!) : 
                "Preço não disponível"
            
            let detailsText = """
                Produto: \(product.name ?? "Produto desconhecido")
                Preço: \(priceText)
                Quantidade: \(product.quantity ?? 0)
                """
            cell.configure(with: detailsText)
        }

        return cell
    }
}
