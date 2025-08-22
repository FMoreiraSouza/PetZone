import UIKit

final class LoginView: UIView {
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LoginPet"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.layer.borderColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8.0
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Senha"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8.0
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Entrar", for: .normal)
        button.backgroundColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cadastre-se", for: .normal)
        button.setTitleColor(UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Esqueci a senha", for: .normal)
        button.setTitleColor(UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        configureTextFields()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 1, green: 0.98, blue: 0.98, alpha: 1)
        addSubview(logoImageView)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(registerButton)
        addSubview(forgotPasswordButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 250),
            logoImageView.widthAnchor.constraint(equalToConstant: 250),
            
            emailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30),
            registerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.widthAnchor.constraint(equalToConstant: 150),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func configureTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .go
        emailTextField.tag = 0
        passwordTextField.tag = 1
    }
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
