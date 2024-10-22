import UIKit

final class RegisterView: UIView {
    
    let nameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let confirmPasswordTextField = UITextField()
    let registerButton = UIButton()
    
    weak var delegate: RegisterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        
        let textFields = [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField]
        let placeholders = ["Nome", "E-mail", "Senha", "Confirme a Senha"]
        
        for (index, field) in textFields.enumerated() {
            field.placeholder = placeholders[index]
            field.borderStyle = .roundedRect
            field.layer.borderWidth = 1.0
            field.layer.borderColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0).cgColor
            field.layer.cornerRadius = 8.0
            field.translatesAutoresizingMaskIntoConstraints = false
            field.autocapitalizationType = .none
            
            if index >= 2 {
                field.isSecureTextEntry = true
            }
            
            addSubview(field)
        }
        
        registerButton.setTitle("Registrar", for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 5
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(registerButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            nameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            nameTextField.widthAnchor.constraint(equalToConstant: 300),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            emailTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
            emailTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
            
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
            
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
            confirmPasswordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
            
            registerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 24),
            registerButton.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    @objc private func registerButtonTapped() {
        delegate?.didTapRegister(
            name: nameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text,
            confirmPassword: confirmPasswordTextField.text
        )
    }
}
