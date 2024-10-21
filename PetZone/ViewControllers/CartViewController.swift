import UIKit

// MARK: - CartViewController

class CartViewController: UIViewController, UITableViewDataSource {

    var cartProducts: [Cart] = []  // Lista de itens do carrinho
    private let tableView = UITableView()
    private let cartService = CartService() // Instância do serviço de carrinho

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
        fetchCartItems() // Busca os itens do carrinho ao carregar a view
    }

    private func setupTableView() {
        tableView.register(
            CartTableCell.self, forCellReuseIdentifier: CartTableCell.identifier
        )
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(totalLabel)
        view.addSubview(paymentButton)  // Adiciona o botão de pagamento à view

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor),  // Coloca a tabela acima do totalLabel

            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalLabel.bottomAnchor.constraint(equalTo: paymentButton.topAnchor, constant: -10),
            totalLabel.heightAnchor.constraint(equalToConstant: 50),

            paymentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            paymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            paymentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            paymentButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    // MARK: - Função para buscar os itens do carrinho
    private func fetchCartItems() {
        cartService.fetchCartItems { [weak self] result in
            switch result {
            case .success(let cartItems):
                self?.cartProducts = cartItems // Atualiza a lista de produtos no carrinho
                self?.tableView.reloadData() // Recarrega a tabela para exibir os itens
                self?.updateTotalLabel() // Atualiza o total após buscar os itens
            case .failure(let error):
                print("Erro ao buscar itens do carrinho: \(error.localizedDescription)")
                // Aqui você pode mostrar um alerta ou mensagem de erro na interface se desejar
            }
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.isEmpty ? 1 : cartProducts.count  // Retorna 1 se vazio para mostrar mensagem
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableCell.identifier, for: indexPath) as! CartTableCell

        if cartProducts.isEmpty {
            cell.configure(with: "Nenhum produto adicionado.")
        } else {
            var product = cartProducts[indexPath.row]

            // Desembrulha o preço de forma segura
            let priceText: String
            if let price = product.price {
                priceText = String(format: "$%.2f", price)
            } else {
                priceText = "Preço não disponível"
            }

            // Desembrulha a quantidade de forma segura
            let detailsText = "Produto: \(product.name ?? "Produto desconhecido")\nPreço: \(priceText)\nQuantidade: \(product.quantity ?? 0)"
            cell.configure(with: detailsText)

            // Configura as ações dos botões de quantidade
            cell.onQuantityChange = { [weak self] change in
                guard let self = self else { return }
                let newQuantity = (product.quantity ?? 0) + change
                if newQuantity >= 0 {
                    product.quantity = newQuantity
                    self.cartProducts[indexPath.row] = product  // Atualiza o array
                    tableView.reloadRows(at: [indexPath], with: .none)  // Atualiza a célula

                    // Recalcula e atualiza o total sempre que a quantidade mudar
                    self.updateTotalLabel()
                }
            }
        }

        return cell
    }

    // MARK: - Função para calcular o total do carrinho
    private func calculateTotal() -> Double {
        var total: Double = 0.0
        for product in cartProducts {
            if let price = product.price, let quantity = product.quantity {
                total += price * Double(quantity)
            }
        }
        return total
    }

    // Atualiza o valor total no label
    private func updateTotalLabel() {
        let total = calculateTotal()
        totalLabel.text = String(format: "Total: $%.2f", total)
    }

    // MARK: - Função para navegar para a tela de pagamento
    @objc private func goToPayment() {
        let paymentVC = PaymentViewController()
        paymentVC.totalAmount = calculateTotal()  // Passa o total para a tela de pagamento
        paymentVC.cartProducts = cartProducts  // Passa os produtos do carrinho
        navigationController?.pushViewController(paymentVC, animated: true)
    }
}
