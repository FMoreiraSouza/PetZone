import UIKit

final class LoginController: UIViewController {
    
    private let authService: AuthProtocol
    private lazy var loginView = LoginView()
    
    init(authService: AuthProtocol = AuthService.shared) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = loginView
        loginView.delegate = self
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension LoginController: LoginViewDelegate {
    func didTapLogin(email: String?, password: String?) {
        guard let email = email, isValidEmail(email),
              let password = password, password.count >= 6 else {
            showError("Por favor, insira um email válido e uma senha com pelo menos 6 caracteres.")
            return
        }
        
        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let homeVC = HomeController()
                    self?.navigationController?.setViewControllers([homeVC], animated: true)
                case .failure(let error):
                    self?.showError("Falha no login: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func didTapRegister() {
        let registerVC = RegisterController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func didTapForgotPassword(email: String?) {
        let alert = UIAlertController(
            title: "Recuperar Senha",
            message: "Insira seu email para receber o link de recuperação.",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.text = email
            textField.keyboardType = .emailAddress
        }
        
        let sendAction = UIAlertAction(title: "Enviar", style: .default) { [weak self] _ in
            guard let email = alert.textFields?.first?.text, !email.isEmpty else {
                self?.showError("Email inválido.")
                return
            }
            
            self?.authService.recoverPassword(email: email) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.view.showToast(message: "Email de recuperação enviado!")
                    case .failure(let error):
                        self?.showError(error.localizedDescription)
                    }
                }
            }
        }
        
        alert.addAction(sendAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
}
