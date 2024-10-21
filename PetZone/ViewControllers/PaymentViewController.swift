import UIKit

// MARK: - PaymentViewController

class PaymentViewController: UIViewController {

    var totalAmount: Double = 0.0 // Total a ser pago
    var cartProducts: [Cart] = []
    var products: [Product] = []
    private var pixCodeGenerated = false // Flag para saber se o código Pix foi gerado

    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let paymentMethodSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Pix", "Cartão"])
        segmentedControl.selectedSegmentIndex = 0 // Seleciona Pix por padrão
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
        updatePayButtonTitle() // Atualiza o título do botão ao carregar a view

        // Adiciona um observador para mudanças no segmentedControl
        paymentMethodSegmentedControl.addTarget(self, action: #selector(paymentMethodChanged), for: .valueChanged)

        // Observa quando o app retorna para o estado ativo (após ser minimizado)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        printCartProducts() // Imprime a lista de produtos do carrinho na debug area
        printProducts()
    }

    private func printCartProducts() {
        if cartProducts.isEmpty {
            print("Nenhum produto no carrinho.")
        } else {
            print("Produtos no carrinho:")
            for product in cartProducts {
                // Exibe informações do produto
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
                // Exibe informações do produto
                let name = product.name ?? "Produto desconhecido"
                let price = product.price ?? 0.0
                let quantity = product.quantity ?? 0
                print("Produto: \(name), Preço: $\(price), Quantidade: \(quantity)")
            }
        }
    }

    // Método para imprimir produtos correspondentes ao carrinho
    private func printPurchasedProducts() {
        // Cria um array para armazenar os produtos comprados
        var purchasedProducts: [Product] = []

        // Filtra os produtos do carrinho e os adiciona à lista de comprados
        for cartItem in cartProducts {
            // Acessa o produto a partir do Pointer
            if let productPointer = cartItem.productId, // productId é do tipo Pointer<Product>
               let product = products.first(where: { $0.id == productPointer.objectId}) { // Acessa o id do produto
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
                // Obtém a quantidade do produto no carrinho
                let quantity = product.quantity ?? 0
                print("Produto: \(name), Preço: $\(price), Quantidade: \(quantity)")
            }
        }
    }
    
    private func updateProductQuantities() {
        for cartItem in cartProducts {
            // Acessa o produto a partir do Pointer
            if let productPointer = cartItem.productId, // productId é do tipo Pointer<Product>
               let product = products.first(where: { $0.id == productPointer.objectId }) { // Acessa o id do produto

                // Garante que as quantidades não sejam nil
                let productQuantity = product.quantity ?? 0 // Usa 0 se a quantidade for nil
                let cartItemQuantity = cartItem.quantity ?? 0 // Usa 0 se a quantidade for nil
                
                // Calcula a nova quantidade
                let newQuantity = productQuantity - cartItemQuantity
                
                // Atualiza a quantidade do produto no banco
                updateProductQuantityInDatabase(productId: product.id, newQuantity: newQuantity)
            }
        }
    }

  
    private func updateProductQuantityInDatabase(productId: String, newQuantity: Int) {
        // Cria uma nova query para o Parse
        let query = Product.query()
        
        // Busca o objeto no banco
        query.find { result in
            switch result {
            case .success(let results):
                // Filtra o produto que corresponde ao productId
                if var parseProduct = results.first(where: { $0.id == productId }) {
                    // Atualiza a quantidade, mas não altera o campo `image`
                    parseProduct.quantity = newQuantity
                    
                    // Salva as mudanças
                    parseProduct.save {  saveResult in
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




    // Detecta quando o usuário retorna ao app
    @objc private func handleAppDidBecomeActive() {
        // Verifica se o código Pix foi gerado e o app foi colocado em segundo plano
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

    // MARK: - Função para simular o pagamento
    @objc private func confirmPayment() {
        let selectedPaymentMethod = paymentMethodSegmentedControl.selectedSegmentIndex == 0 ? "Pix" : "Cartão"

        if selectedPaymentMethod == "Pix" {
            let paymentCode = generatePaymentCode() // Gera um código de pagamento
            UIPasteboard.general.string = paymentCode // Copia o código para a área de transferência
            pixCodeGenerated = true // Marca que o código foi gerado

            // Exibir um alerta de confirmação com o código
            let alert = UIAlertController(title: "Pagamento via Pix", message: "Copie o código a seguir para realizar o pagamento: \n\n\(paymentCode)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Copiar", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            // Para a opção Cartão, não fazemos nada por enquanto
            let alert = UIAlertController(title: "Método de Pagamento", message: "Você selecionou Cartão. Esta opção ainda não está disponível.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Função para gerar um código de pagamento fictício
    private func generatePaymentCode() -> String {
        // Gera um código fictício (ex: "PIX123456789")
        let code = "PIX\(Int.random(in: 100000000...999999999))"
        return code
    }

    // Exibe confirmação de pagamento
    // Exibe confirmação de pagamento
    private func showPixPaymentConfirmation() {
        // Simula que o pagamento foi feito ao voltar ao app
        let alert = UIAlertController(title: "Pagamento Confirmado", message: "Seu pagamento via Pix foi confirmado com sucesso!", preferredStyle: .alert)

        // Adiciona uma ação que redireciona para a tela inicial (Home)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.printPurchasedProducts() // Imprime a lista de produtos correspondentes ao carrinho
            self.updateProductQuantities() // Atualiza as quantidades no banco
            
            // Limpa a tabela Cart
            self.clearCart { success in
                if success {
                    self.navigateToHome() // Navega para a tela inicial após limpar o carrinho
                } else {
                    print("Erro ao limpar o carrinho.")
                }
            }
        }))

        present(alert, animated: true, completion: nil)

        pixCodeGenerated = false // Reseta a flag após confirmação
    }

    // Função para limpar todos os itens da tabela Cart
    private func clearCart(completion: @escaping (Bool) -> Void) {
        let query = Cart.query()

        query.find { result in
            switch result {
            case .success(let cartItems):
                // Utiliza Task para gerenciar operações assíncronas
                Task {
                    do {
                        try await withThrowingTaskGroup(of: Void.self) { group in
                            for cartItem in cartItems {
                                group.addTask {
                                    try await cartItem.delete() // Adiciona o 'try' para lidar com exceção
                                }
                            }
                        }
                        completion(true) // Sucesso ao remover todos os itens
                    } catch {
                        print("Erro ao remover os itens do carrinho: \(error.localizedDescription)")
                        completion(false) // Falha ao remover os itens
                    }
                }
            case .failure(let error):
                print("Erro ao buscar os itens do carrinho: \(error.localizedDescription)")
                completion(false)
            }
        }
    }



    // Função para redirecionar o usuário para a tela inicial
    private func navigateToHome() {
        let homeViewController = HomeViewController() // Instancia a tela de Home (substitua pelo seu controlador de Home real)
        navigationController?.setViewControllers([homeViewController], animated: true) // Redireciona para a Home limpando a pilha de navegação
    }

    // MARK: - Função chamada quando o método de pagamento é alterado
    @objc private func paymentMethodChanged() {
        updatePayButtonTitle() // Atualiza o título do botão
    }
}
