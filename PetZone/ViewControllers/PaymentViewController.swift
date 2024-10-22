import UIKit

class PaymentViewController: UIViewController {

    var totalAmount: Double = 0.0
    var cartProducts: [Cart] = []
    var products: [Product] = []
    private var pixCodeGenerated = false

    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let paymentMethodSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Pix", "Cartão"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(confirmPayment), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        updateTotalLabel()
        updatePayButtonTitle()
        paymentMethodSegmentedControl.addTarget(self, action: #selector(paymentMethodChanged), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        printCartProducts()
        printProducts()
    }

    private func printCartProducts() {
        if cartProducts.isEmpty {
            print("Nenhum produto no carrinho.")
        } else {
            print("Produtos no carrinho:")
            for product in cartProducts {
                let name = product.name ?? "Produto desconhecido"
                let price = product.price ?? 0.0
                let quantity = product.quantity ?? 0
                print("Produto: \(name), Preço: $\(price), Quantidade: \(quantity)")
            }
        }
    }

    private func printProducts() {
        if products.isEmpty {
            print("Nenhum produto encontrado.")
        } else {
            print("Produtos na loja:")
            for product in products {
                let name = product.name ?? "Produto desconhecido"
                let price = product.price ?? 0.0
                let quantity = product.quantity ?? 0
                print("Produto: \(name), Preço: $\(price), Quantidade: \(quantity)")
            }
        }
    }

    private func printPurchasedProducts() {
        var purchasedProducts: [Product] = []
        for cartItem in cartProducts {
            if let productPointer = cartItem.productId,
               let product = products.first(where: { $0.id == productPointer.objectId }) {
                purchasedProducts.append(product)
            }
        }

        if purchasedProducts.isEmpty {
            print("Nenhum produto correspondente encontrado no carrinho.")
        } else {
            print("Produtos comprados:")
            for product in purchasedProducts {
                let name = product.name ?? "Produto desconhecido"
                let price = product.price ?? 0.0
                let quantity = product.quantity ?? 0
                print("Produto: \(name), Preço: $\(price), Quantidade: \(quantity)")
            }
        }
    }
    
    private func updateProductQuantities() {
        for cartItem in cartProducts {
            if let productPointer = cartItem.productId,
               let product = products.first(where: { $0.id == productPointer.objectId }) {
                let productQuantity = product.quantity ?? 0
                let cartItemQuantity = cartItem.quantity ?? 0
                let newQuantity = productQuantity - cartItemQuantity
                updateProductQuantityInDatabase(productId: product.id, newQuantity: newQuantity)
            }
        }
    }

    private func updateProductQuantityInDatabase(productId: String, newQuantity: Int) {
        let query = Product.query()
        query.find { result in
            switch result {
            case .success(let results):
                if var parseProduct = results.first(where: { $0.id == productId }) {
                    parseProduct.quantity = newQuantity
                    parseProduct.save { saveResult in
                        switch saveResult {
                        case .success:
                            print("Quantidade do produto \(productId) atualizada para \(newQuantity).")
                        case .failure(let error):
                            print("Falha ao atualizar a quantidade do produto: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("Produto com ID \(productId) não encontrado.")
                }
            case .failure(let error):
                print("Falha ao buscar o produto no Back4App: \(error.localizedDescription)")
            }
        }
    }

    @objc private func handleAppDidBecomeActive() {
        if pixCodeGenerated {
            showPixPaymentConfirmation()
        }
    }

    private func setupUI() {
        view.addSubview(totalLabel)
        view.addSubview(paymentMethodSegmentedControl)
        view.addSubview(payButton)

        NSLayoutConstraint.activate([
            totalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            paymentMethodSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentMethodSegmentedControl.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 20),
            payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payButton.topAnchor.constraint(equalTo: paymentMethodSegmentedControl.bottomAnchor, constant: 20),
            payButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func updateTotalLabel() {
        totalLabel.text = String(format: "Total a Pagar: $%.2f", totalAmount)
    }

    private func updatePayButtonTitle() {
        let buttonTitle = paymentMethodSegmentedControl.selectedSegmentIndex == 0 ? "Gerar Código Pix" : "Confirmar Pagamento"
        payButton.setTitle(buttonTitle, for: .normal)
    }

    @objc private func confirmPayment() {
        let selectedPaymentMethod = paymentMethodSegmentedControl.selectedSegmentIndex == 0 ? "Pix" : "Cartão"

        if selectedPaymentMethod == "Pix" {
            let paymentCode = generatePaymentCode()
            UIPasteboard.general.string = paymentCode
            pixCodeGenerated = true

            let alert = UIAlertController(title: "Pagamento via Pix", message: "Copie o código a seguir para realizar o pagamento: \n\n\(paymentCode)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Copiar", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Método de Pagamento", message: "Você selecionou Cartão. Esta opção ainda não está disponível.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    private func generatePaymentCode() -> String {
        let code = "PIX\(Int.random(in: 100000000...999999999))"
        return code
    }

    private func showPixPaymentConfirmation() {
        let alert = UIAlertController(title: "Pagamento Confirmado", message: "Seu pagamento via Pix foi confirmado com sucesso!", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.printPurchasedProducts()
            self.updateProductQuantities()
            self.clearCart { success in
                if success {
                    self.navigateToHome()
                } else {
                    print("Erro ao limpar o carrinho.")
                }
            }
        }))

        present(alert, animated: true, completion: nil)
        pixCodeGenerated = false
    }

    private func clearCart(completion: @escaping (Bool) -> Void) {
        let query = Cart.query()

        query.find { result in
            switch result {
            case .success(let cartItems):
                Task {
                    do {
                        try await withThrowingTaskGroup(of: Void.self) { group in
                            for cartItem in cartItems {
                                group.addTask {
                                    try await cartItem.delete()
                                }
                            }
                        }
                        completion(true)
                    } catch {
                        print("Erro ao remover os itens do carrinho: \(error.localizedDescription)")
                        completion(false)
                    }
                }
            case .failure(let error):
                print("Erro ao buscar os itens do carrinho: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

    private func navigateToHome() {
        let homeViewController = HomeViewController()
        navigationController?.setViewControllers([homeViewController], animated: true)
    }

    @objc private func paymentMethodChanged() {
        updatePayButtonTitle()
    }
}
