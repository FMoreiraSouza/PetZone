import UIKit

final class PaymentController: UIViewController {
    
    var totalAmount: Double = 0.0
    var cartProducts: [Cart] = []
    var products: [Product] = []
    
    private var pixCodeGenerated = false
    private var paymentInProgress = false
    private let paymentService: PaymentProtocol
    private lazy var paymentView = PaymentView()
    
    init(paymentService: PaymentProtocol = PaymentService()) {
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
        setupView()
        setupActions()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupView() {
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
        
        paymentView.onCreditCardPayment = { [weak self] cardData in
            self?.processCreditCardPayment(
                cardNumber: cardData.number,
                cardHolder: cardData.holder,
                expiryDate: cardData.expiry,
                cvv: cardData.cvv
            )
        }
    }
    
    @objc private func paymentMethodChanged() {
        let isPixSelected = paymentView.paymentMethodSegmentedControl.selectedSegmentIndex == 0
        paymentView.updatePayButtonTitle(isPixSelected: isPixSelected)
    }
    
    @objc private func confirmPayment() {
        guard !paymentInProgress else { return }
        paymentInProgress = true
        
        let isPixSelected = paymentView.paymentMethodSegmentedControl.selectedSegmentIndex == 0
        
        if isPixSelected {
            handlePixPayment()
        } else {
            paymentView.showCreditCardForm()
        }
    }
    
    private func processCreditCardPayment(cardNumber: String, cardHolder: String, expiryDate: String, cvv: String) {
        guard validateCreditCardData(cardNumber: cardNumber, cardHolder: cardHolder, expiryDate: expiryDate, cvv: cvv) else {
            paymentInProgress = false
            showAlert(title: "Erro", message: "Por favor, preencha todos os campos corretamente.")
            return
        }
        
        showProcessingAlert { [weak self] in
            self?.showPaymentConfirmation(isCreditCard: true)
        }
    }
    
    private func validateCreditCardData(cardNumber: String, cardHolder: String, expiryDate: String, cvv: String) -> Bool {
        let cleanedCardNumber = cardNumber.replacingOccurrences(of: " ", with: "")
        guard cleanedCardNumber.count >= 13 && cleanedCardNumber.count <= 19 else { return false }
        guard !cardHolder.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard expiryDate.count == 5 && expiryDate.contains("/") else { return false }
        guard cvv.count >= 3 && cvv.count <= 4 else { return false }
        
        return true
    }
    
    private func showProcessingAlert(completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Processando pagamento...", message: nil, preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.dismiss(animated: true) {
                completion()
            }
        }
    }
    
    private func handlePixPayment() {
        let paymentCode = generatePaymentCode()
        UIPasteboard.general.string = paymentCode
        pixCodeGenerated = true
        
        showAlert(
            title: "Pagamento via Pix",
            message: "Copie o código a seguir para realizar o pagamento: \n\n\(paymentCode)",
            handler: { [weak self] _ in
                self?.paymentInProgress = false
            }
        )
    }
    
    @objc private func handleAppDidBecomeActive() {
        if pixCodeGenerated {
            showPixPaymentConfirmation()
        }
    }
    
    private func showPixPaymentConfirmation() {
        showPaymentConfirmation(isCreditCard: false)
        pixCodeGenerated = false
    }
    
    private func showPaymentConfirmation(isCreditCard: Bool = false) {
        let message = isCreditCard ?
            "Seu pagamento com cartão foi processado com sucesso!" :
            "Seu pagamento via Pix foi confirmado com sucesso!"
        
        showAlert(
            title: "Pagamento Confirmado",
            message: message,
            handler: { [weak self] _ in
                self?.finalizePurchase()
            }
        )
    }
    
    private func finalizePurchase() {
        updateProductQuantities()
    }
    
    private func generatePaymentCode() -> String {
        return "PIX\(Int.random(in: 100000000...999999999))"
    }
    
    private func updateProductQuantities() {
        let dispatchGroup = DispatchGroup()
        var allUpdatesSuccessful = true
        
        print("Iniciando atualização de quantidades...")
        print("Produtos no carro de conpras: \(cartProducts.count)")
        
        for cartItem in cartProducts {
            if let productPointer = cartItem.productId,
               let product = products.first(where: { $0.id == productPointer.objectId }) {
                
                let productQuantity = product.quantity ?? 0
                let cartItemQuantity = cartItem.quantity ?? 0
                let newQuantity = productQuantity - cartItemQuantity
                
                print("Produto: \(product.name ?? "Sem nome")")
                print("Quantidade atual: \(productQuantity)")
                print("Quantidade comprada: \(cartItemQuantity)")
                print("Nova quantidade: \(newQuantity)")
                
                dispatchGroup.enter()
                paymentService.updateProductQuantity(
                    productId: product.id,
                    newQuantity: newQuantity
                ) { success in
                    if !success {
                        print("Falha ao atualizar quantidade do produto \(product.id)")
                        allUpdatesSuccessful = false
                    } else {
                        print("Quantidade atualizada com sucesso para o produto \(product.id)")
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            if allUpdatesSuccessful {
                print("Todas as quantidades foram atualizadas com sucesso")
                self?.clearCart()
            } else {
                print("Algumas atualizações falharam")
                self?.paymentInProgress = false
                self?.showAlert(title: "Erro", message: "Não foi possível atualizar todos os produtos.")
            }
        }
    }
    
    private func clearCart() {
        paymentService.clearCart { [weak self] success in
            DispatchQueue.main.async {
                self?.paymentInProgress = false
                if success {
                    print("Carro de conpras limpo com sucesso")
                    self?.navigateToHome()
                } else {
                    print("Falha ao limpar o carro de conpras")
                    self?.showAlert(title: "Erro", message: "Não foi possível limpar o carro de conpras.")
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
