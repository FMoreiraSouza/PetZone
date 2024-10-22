import UIKit

class CartViewController: UIViewController, UITableViewDataSource {

    var products: [Product] = []
    var cartProducts: [Cart] = []
    private let tableView = UITableView()
    private let cartService = CartService()

    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.text = "Total: $0.00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let paymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ir para pagamento", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToPayment), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        fetchCartItems()
    }

    private func setupTableView() {
        tableView.register(
            CartTableCell.self, forCellReuseIdentifier: CartTableCell.identifier
        )
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(totalLabel)
        view.addSubview(paymentButton)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor),

            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalLabel.bottomAnchor.constraint(equalTo: paymentButton.topAnchor, constant: -10),
            totalLabel.heightAnchor.constraint(equalToConstant: 50),

            paymentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            paymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            paymentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            paymentButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func fetchCartItems() {
        cartService.fetchCartItems { [weak self] result in
            switch result {
            case .success(let cartItems):
                self?.cartProducts = cartItems
                self?.tableView.reloadData()
                self?.updateTotalLabel()
            case .failure(let error):
                print("Erro ao buscar itens do carrinho: \(error.localizedDescription)")
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.isEmpty ? 1 : cartProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableCell.identifier, for: indexPath) as! CartTableCell

        if cartProducts.isEmpty {
            cell.configure(with: "Nenhum produto adicionado.")
        } else {
            let product = cartProducts[indexPath.row]

            let priceText: String
            if let price = product.price {
                priceText = String(format: "$%.2f", price)
            } else {
                priceText = "Preço não disponível"
            }

            let detailsText = "Produto: \(product.name ?? "Produto desconhecido")\nPreço: \(priceText)\nQuantidade: \(product.quantity ?? 0)"
            cell.configure(with: detailsText)
        }

        return cell
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
        totalLabel.text = String(format: "Total: $%.2f", total)
    }

    @objc private func goToPayment() {
        let paymentVC = PaymentViewController()
        paymentVC.totalAmount = calculateTotal()
        paymentVC.products = products
        paymentVC.cartProducts = cartProducts
        navigationController?.pushViewController(paymentVC, animated: true)
    }
}
