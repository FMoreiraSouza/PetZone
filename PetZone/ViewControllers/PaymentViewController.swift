import UIKit

// MARK: - PaymentViewController

class PaymentViewController: UIViewController {

    var totalAmount: Double = 0.0 // Total a ser pago
    var cartProducts: [Cart] = [] // Produtos no carrinho
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
    private func showPixPaymentConfirmation() {
        // Simula que o pagamento foi feito ao voltar ao app
        let alert = UIAlertController(title: "Pagamento Confirmado", message: "Seu pagamento via Pix foi confirmado com sucesso!", preferredStyle: .alert)
        
        // Adiciona uma ação que redireciona para a tela inicial (Home)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigateToHome() // Chama a função para redirecionar à tela inicial
        }))
        
        present(alert, animated: true, completion: nil)
        
        pixCodeGenerated = false // Reseta a flag após confirmação
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
