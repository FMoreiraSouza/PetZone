import UIKit

final class RegisterController: UIViewController {
    private let authService: AuthProtocol
    private lazy var registerView = RegisterView()
    
    init(authService: AuthProtocol = AuthService.shared) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = registerView
        setupRegisterActions()
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
        
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    private func setupRegisterActions() {
        registerView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    @objc private func registerButtonTapped() {
        guard let name = registerView.nameTextField.text, ValidationUtils.isValidName(name) else {
            showAlert(title: "Atenção", message: "Por favor, preencha o campo Nome.")
            return
        }
        
        guard let email = registerView.emailTextField.text, ValidationUtils.isValidEmail(email) else {
            showAlert(title: "Atenção", message: "Por favor, preencha um e-mail válido.")
            return
        }
        
        guard let password = registerView.passwordTextField.text, ValidationUtils.isValidPassword(password) else {
            showAlert(title: "Atenção", message: "A senha deve ter pelo menos 6 caracteres.")
            return
        }
        
        guard let confirmPassword = registerView.confirmPasswordTextField.text,
              ValidationUtils.passwordsMatch(password, confirmPassword) else {
            showAlert(title: "Atenção", message: "As senhas não coincidem.")
            return
        }
        
        authService.register(name: name, email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.showAlert(title: "Sucesso", message: "Registro concluído!") {
                        let loginVC = LoginController()
                        self?.navigationController?.setViewControllers([loginVC], animated: true)
                    }
                case .failure(let error):
                    self?.showAlert(title: "Erro", message: error.localizedDescription)
                }
            }
        }
    }
}
