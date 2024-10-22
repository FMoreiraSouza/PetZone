import UIKit

class RegisterViewController: UIViewController {

    let nameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let confirmPasswordTextField = UITextField()
    let registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.white

        // Nome
        nameTextField.placeholder = "Nome"
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0).cgColor
        nameTextField.layer.cornerRadius = 8.0
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.autocapitalizationType = .none
        view.addSubview(nameTextField)

        // E-mail
        emailTextField.placeholder = "E-mail"
        emailTextField.borderStyle = .roundedRect
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0).cgColor
        emailTextField.layer.cornerRadius = 8.0
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.autocapitalizationType = .none
        view.addSubview(emailTextField)

        // Senha
        passwordTextField.placeholder = "Senha"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0).cgColor
        passwordTextField.layer.cornerRadius = 8.0
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.autocapitalizationType = .none
        view.addSubview(passwordTextField)

        // Confirmação de Senha
        confirmPasswordTextField.placeholder = "Confirme a Senha"
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.layer.borderWidth = 1.0
        confirmPasswordTextField.layer.borderColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0).cgColor
        confirmPasswordTextField.layer.cornerRadius = 8.0
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.autocapitalizationType = .none
        view.addSubview(confirmPasswordTextField)

        // Botão de Registro
        registerButton.setTitle("Registrar", for: .normal)
        registerButton.backgroundColor = UIColor.systemBlue
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 5
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(onRegister), for: .touchUpInside)
        view.addSubview(registerButton)

        // Definindo as constraints
        NSLayoutConstraint.activate([
            // Nome
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            nameTextField.widthAnchor.constraint(equalToConstant: 300),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),

            // E-mail
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            emailTextField.widthAnchor.constraint(equalToConstant: 300),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            // Senha
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            // Confirmação de Senha
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 300),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40),

            // Botão de Registro
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 24),
            registerButton.widthAnchor.constraint(equalToConstant: 300),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    @objc func onRegister() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(message: "Por favor, preencha o campo Nome.")
            return
        }

        guard let email = emailTextField.text, isValidEmail(email) else {
            showAlert(message: "Por favor, preencha um e-mail válido.")
            return
        }

        guard let password = passwordTextField.text, password.count >= 6 else {
            showAlert(message: "A senha deve ter pelo menos 6 caracteres.")
            return
        }

        guard let confirmPassword = confirmPasswordTextField.text, confirmPassword == password else {
            showAlert(message: "As senhas não coincidem.")
            return
        }

        AuthService.shared.registerUser(name: name, email: email, password: password) { success, error in
            if success {
                print("Registro bem-sucedido!")
                let loginVC = LoginViewController()
                self.navigationController?.setViewControllers([loginVC], animated: true)
            } else if let error = error {
                print("Erro ao registrar: \(error.localizedDescription)")
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
