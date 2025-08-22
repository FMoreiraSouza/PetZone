import UIKit

final class HomeView: UIView {
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
        tableView.backgroundColor = UIColor(red: 1, green: 0.98, blue: 0.98, alpha: 1)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCartButtonAction(target: Any?, action: Selector) {
        cartButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 1, green: 0.98, blue: 0.98, alpha: 1)
        addSubview(titleLabel)
        addSubview(cartButton)
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            cartButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            cartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
