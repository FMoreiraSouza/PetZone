import UIKit

final class HomeView: UIView {
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PetZone"
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "cart.fill"), for: .normal)
        button.tintColor = UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setCartButtonAction(target: Any?, action: Selector) {
        cartButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = UIColor(red: 1, green: 0.98, blue: 0.98, alpha: 1)
        addSubview(titleLabel)
        addSubview(cartButton)
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Título alinhado à esquerda
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // Carrinho alinhado à direita
            cartButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            cartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Tabela abaixo dos elementos superiores
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
