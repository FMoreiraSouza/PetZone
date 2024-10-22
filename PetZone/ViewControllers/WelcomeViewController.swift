import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1, green: 0.98, blue: 0.98, alpha: 1)

        let logoImageView = UIImageView(image: UIImage(named: "WelcomePet"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)

        let titleLabel = UILabel()
        titleLabel.text = "Bem-vindo ao PetZone"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let messageLabel = UILabel()
        messageLabel.text = "Seu pet shop digital!"
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)

        let loginButton = UIButton(type: .system)
        loginButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        loginButton.tintColor = UIColor.white
        loginButton.setTitleColor(UIColor(red: 1, green: 0.98, blue: 0.98, alpha: 1), for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0)

        let buttonSize: CGFloat = 50
        loginButton.layer.cornerRadius = buttonSize / 2
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(openLoginScreen), for: .touchUpInside)
        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 250),
            logoImageView.widthAnchor.constraint(equalToConstant: 250),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            loginButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 32),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: buttonSize),
            loginButton.heightAnchor.constraint(equalToConstant: buttonSize),
        ])
    }

    @objc func openLoginScreen() {
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}
