import UIKit

final class CartView: UIView {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.text = "Total: $0.00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let paymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ir para pagamento", for: .normal)
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
        addSubview(tableView)
        addSubview(totalLabel)
        addSubview(paymentButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor),
            
            totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            totalLabel.bottomAnchor.constraint(equalTo: paymentButton.topAnchor, constant: -10),
            totalLabel.heightAnchor.constraint(equalToConstant: 50),
            
            paymentButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            paymentButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            paymentButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            paymentButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
