import UIKit

final class PaymentView: UIView {
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let paymentMethodSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Pix", "Cartão"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onCreditCardFormRequested: (() -> Void)?
    var onCreditCardPayment: ((String, String, String, String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        addSubview(totalLabel)
        addSubview(paymentMethodSegmentedControl)
        addSubview(payButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            totalLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            totalLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            paymentMethodSegmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            paymentMethodSegmentedControl.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 30),
            paymentMethodSegmentedControl.widthAnchor.constraint(equalToConstant: 200),
            
            payButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            payButton.topAnchor.constraint(equalTo: paymentMethodSegmentedControl.bottomAnchor, constant: 30),
            payButton.widthAnchor.constraint(equalToConstant: 200),
            payButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func updateTotalLabel(amount: Double) {
        totalLabel.text = String(format: "Total a Pagar: $%.2f", amount)
    }
    
    func updatePayButtonTitle(isPixSelected: Bool) {
        let buttonTitle = isPixSelected ? "Gerar Código Pix" : "Adicionar cartão"
        payButton.setTitle(buttonTitle, for: .normal)
    }
    
    func showCreditCardForm() {
        presentCreditCardAlert()
    }
    
    private func presentCreditCardAlert() {
        guard let viewController = findViewController() else { return }
        
        let alert = UIAlertController(
            title: "Pagamento com Cartão",
            message: "Preencha os dados do cartão",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Número do Cartão"
            textField.keyboardType = .numberPad
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Nome no Cartão"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Validade (MM/AA)"
            textField.keyboardType = .numbersAndPunctuation
        }
        
        alert.addTextField { textField in
            textField.placeholder = "CVV"
            textField.keyboardType = .numberPad
            textField.isSecureTextEntry = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        let payAction = UIAlertAction(title: "Pagar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            let cardNumber = alert.textFields?[0].text ?? ""
            let cardHolder = alert.textFields?[1].text ?? ""
            let expiryDate = alert.textFields?[2].text ?? ""
            let cvv = alert.textFields?[3].text ?? ""
            
            self.onCreditCardPayment?(cardNumber, cardHolder, expiryDate, cvv)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(payAction)
        
        viewController.present(alert, animated: true)
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}
