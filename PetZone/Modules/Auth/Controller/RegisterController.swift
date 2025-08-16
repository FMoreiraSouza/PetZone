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
        registerView.delegate = self
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
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

extension RegisterController: RegisterViewDelegate {
    func didTapRegister(name: String?, email: String?, password: String?, confirmPassword: String?) {
        guard let name = name, !name.isEmpty else {
            showAlert(title: "Atenção", message: "Por favor, preencha o campo Nome.")
            return
        }
        
        guard let email = email, isValidEmail(email) else {
            showAlert(title: "Atenção", message: "Por favor, preencha um e-mail válido.")
            return
        }
        
        guard let password = password, password.count >= 6 else {
            showAlert(title: "Atenção", message: "A senha deve ter pelo menos 6 caracteres.")
            return
        }
        
        guard let confirmPassword = confirmPassword, confirmPassword == password else {
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
