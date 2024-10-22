import UIKit

final class PaymentController: UIViewController {
    
    var totalAmount: Double = 0.0
    var cartProducts: [Cart] = []
    var products: [Product] = []
    
    private var pixCodeGenerated = false
    private let paymentService: PaymentServiceProtocol
    private lazy var paymentView = PaymentView()
    
    init(paymentService: PaymentServiceProtocol = PaymentService()) {
        self.paymentService = paymentService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = paymentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        NotificationCenter.default.addObserver(
            self, 
            selector: #selector(handleAppDidBecomeActive), 
            name: UIApplication.didBecomeActiveNotification, 
            object: nil
        )
    }
    
    private func setupUI() {
        paymentView.updateTotalLabel(amount: totalAmount)
        paymentView.updatePayButtonTitle(isPixSelected: true)
    }
    
    private func setupActions() {
        paymentView.paymentMethodSegmentedControl.addTarget(
            self, 
            action: #selector(paymentMethodChanged), 
            for: .valueChanged
        )
        
        paymentView.payButton.addTarget(
            self, 
            action: #selector(confirmPayment), 
            for: .touchUpInside
        )
    }
    
    @objc private func paymentMethodChanged() {
        let isPixSelected = paymentView.paymentMethodSegmentedControl.selectedSegmentIndex == 0
        paymentView.updatePayButtonTitle(isPixSelected: isPixSelected)
    }
    
    @objc private func confirmPayment() {
        let isPixSelected = paymentView.paymentMethodSegmentedControl.selectedSegmentIndex == 0
        
        if isPixSelected {
            handlePixPayment()
        } else {
            showAlert(title: "Método de Pagamento", 
                     message: "Você selecionou Cartão. Esta opção ainda não está disponível.")
        }
    }
    
    private func handlePixPayment() {
        let paymentCode = generatePaymentCode()
        UIPasteboard.general.string = paymentCode
        pixCodeGenerated = true
        
        showAlert(
            title: "Pagamento via Pix", 
            message: "Copie o código a seguir para realizar o pagamento: \n\n\(paymentCode)"
        )
    }
    
    @objc private func handleAppDidBecomeActive() {
        if pixCodeGenerated {
            showPixPaymentConfirmation()
        }
    }
    
    private func showPixPaymentConfirmation() {
        showAlert(
            title: "Pagamento Confirmado", 
            message: "Seu pagamento via Pix foi confirmado com sucesso!", 
            handler: { [weak self] _ in
                self?.finalizePurchase()
            }
        )
        pixCodeGenerated = false
    }
    
    private func finalizePurchase() {
        updateProductQuantities()
        clearCart()
    }
    
    private func generatePaymentCode() -> String {
        return "PIX\(Int.random(in: 100000000...999999999))"
    }
    
    private func updateProductQuantities() {
        for cartItem in cartProducts {
            if let productPointer = cartItem.productId,
               let product = products.first(where: { $0.id == productPointer.objectId }) {
                let productQuantity = product.quantity ?? 0
                let cartItemQuantity = cartItem.quantity ?? 0
                let newQuantity = productQuantity - cartItemQuantity
                
                paymentService.updateProductQuantity(
                    productId: product.id, 
                    newQuantity: newQuantity
                ) { success in
                    if !success {
                        print("Falha ao atualizar quantidade do produto \(product.id)")
                    }
                }
            }
        }
    }
    
    private func clearCart() {
        paymentService.clearCart { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.navigateToHome()
                } else {
                    self?.showAlert(title: "Erro", message: "Não foi possível limpar o carrinho.")
                }
            }
        }
    }
    
    private func navigateToHome() {
        let homeViewController = HomeController()
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
    
    private func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        present(alert, animated: true)
    }
}
