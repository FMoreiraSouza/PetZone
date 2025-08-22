import UIKit

final class SideMenuView: UIView {
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Bem-vindo,"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var aboutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sobre", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sair", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var aboutButtonAction: (() -> Void)?
    var logoutButtonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with userName: String) {
        nameLabel.text = userName
    }
    
    private func setupView() {
        backgroundColor = UIColor.lightGray
        
        addSubview(welcomeLabel)
        addSubview(nameLabel)
        addSubview(aboutButton)
        addSubview(logoutButton)
        
        aboutButton.addTarget(self, action: #selector(aboutButtonTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.bottomAnchor.constraint(equalTo: aboutButton.topAnchor, constant: -30),
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            aboutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            aboutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            aboutButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            
            logoutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            logoutButton.topAnchor.constraint(equalTo: aboutButton.bottomAnchor, constant: 16)
        ])
    }
    
    @objc private func aboutButtonTapped() {
        aboutButtonAction?()
    }
    
    @objc private func logoutButtonTapped() {
        logoutButtonAction?()
    }
}
