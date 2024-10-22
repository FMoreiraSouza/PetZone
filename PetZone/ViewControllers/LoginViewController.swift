import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1, green: 0.98, blue: 0.98, alpha: 1)

        let petSymbolImageView = UIImageView(image: UIImage(named: "LoginPet"))
        petSymbolImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(petSymbolImageView)

        let emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0).cgColor
        emailTextField.layer.cornerRadius = 8.0
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.autocapitalizationType = .none

        let passwordTextField = UITextField()
        passwordTextField.placeholder = "Senha"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0).cgColor
        passwordTextField.layer.cornerRadius = 8.0
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.autocapitalizationType = .none

        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Entrar", for: .normal)
        loginButton.backgroundColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        loginButton.layer.cornerRadius = 12.0
        
        let registerButton = UIButton(type: .system)
        registerButton.setTitle("Cadastre-se", for: .normal)
        registerButton.setTitleColor(UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0), for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(navToRegisterView), for: .touchUpInside)
        registerButton.layer.cornerRadius = 12.0
        
        let forgotPasswordButton = UIButton(type: .system)
        forgotPasswordButton.setTitle("Esqueci a senha", for: .normal)
        forgotPasswordButton.setTitleColor(UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0), for: .normal)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.addTarget(self, action: #selector(onForgotPassword), for: .touchUpInside)

        view.addSubview(petSymbolImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(forgotPasswordButton)

        NSLayoutConstraint.activate([
            petSymbolImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            petSymbolImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            petSymbolImageView.heightAnchor.constraint(equalToConstant: 250),
            petSymbolImageView.widthAnchor.constraint(equalToConstant: 250),

            emailTextField.topAnchor.constraint(equalTo: petSymbolImageView.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalToConstant: 150),

            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.widthAnchor.constraint(equalToConstant: 150),

            forgotPasswordButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc func onLogin() {
        guard let emailTextField = view.subviews.compactMap({ $0 as? UITextField }).first(where: { $0.placeholder == "Email" }),
              let passwordTextField = view.subviews.compactMap({ $0 as? UITextField }).first(where: { $0.placeholder == "Senha" }),
              let email = emailTextField.text, isValidEmail(email),
              let password = passwordTextField.text, isValidPassword(password) else {
            let alert = UIAlertController(title: "Erro", message: "Por favor, insira um email válido e uma senha com pelo menos 6 caracteres.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        AuthService.shared.loginUser(email: email, password: password) { success, error in
            if success {
                print("Login bem-sucedido!")
                DispatchQueue.main.async {
                    let homeViewController = HomeViewController()
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                }
            } else if let error = error {
                print("Erro no login: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Erro", message: "Falha no login: E-mail ou senha não correspondem!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    @objc func navToRegisterView() {
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @objc func onForgotPassword() {
        let alert = UIAlertController(title: "Recuperar Senha", message: "Insira seu email para receber o link de recuperação.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        
        let sendAction = UIAlertAction(title: "Enviar", style: .default) { _ in
            guard let email = alert.textFields?.first?.text, !email.isEmpty else {
                print("Email inválido.")
                return
            }
            
            AuthService.shared.recoverPassword(email: email) { success, error in
                if success {
                    print("Email de recuperação enviado!")
                    self.view.showToast(message: "Email de recuperação enviado!")
                } else if let error = error {
                    print("Erro ao enviar o email: \(error.localizedDescription)")
                    let errorAlert = UIAlertController(title: "Erro", message: "Não foi possível enviar o email: \(error.localizedDescription)", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        }
        
        alert.addAction(sendAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
