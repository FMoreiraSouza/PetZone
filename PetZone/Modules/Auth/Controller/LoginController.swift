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
        setupLoginActions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissal()
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
        
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupLoginActions() {
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        loginView.forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        guard let email = loginView.emailTextField.text, ValidationUtils.isValidEmail(email),
              let password = loginView.passwordTextField.text, ValidationUtils.isValidPassword(password) else {
            showError("Por favor, insira um email válido e uma senha com pelo menos 6 caracteres.")
            return
        }
        
        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let homeVC = HomeController()
                    let navController = UINavigationController(rootViewController: homeVC)
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = navController
                        window.makeKeyAndVisible()
                    }
                    
                case .failure(let error):
                    self?.showError("Falha no login: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func registerButtonTapped() {
        let registerVC = RegisterController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc private func forgotPasswordButtonTapped() {
        let alert = UIAlertController(
            title: "Recuperar Senha",
            message: "Insira seu email para receber o link de recuperação.",
            preferredStyle: .alert
        )
        
        alert.addTextField { [weak self] textField in
            textField.placeholder = "Email"
            textField.text = self?.loginView.emailTextField.text
            textField.keyboardType = .emailAddress
        }
        
        let sendAction = UIAlertAction(title: "Enviar", style: .default) { [weak self] _ in
            guard let email = alert.textFields?.first?.text, ValidationUtils.isValidEmail(email) else {
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
