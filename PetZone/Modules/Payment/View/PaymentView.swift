import UIKit

final class PaymentView: UIView {
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
            
            paymentMethodSegmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            paymentMethodSegmentedControl.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 20),
            
            payButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            payButton.topAnchor.constraint(equalTo: paymentMethodSegmentedControl.bottomAnchor, constant: 20),
            payButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func updateTotalLabel(amount: Double) {
        totalLabel.text = String(format: "Total a Pagar: $%.2f", amount)
    }
    
    func updatePayButtonTitle(isPixSelected: Bool) {
        let buttonTitle = isPixSelected ? "Gerar Código Pix" : "Confirmar Pagamento"
        payButton.setTitle(buttonTitle, for: .normal)
    }
}
