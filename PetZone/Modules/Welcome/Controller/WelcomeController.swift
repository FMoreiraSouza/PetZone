import UIKit

class WelcomeController: UIViewController {
    
    private var welcomeView: WelcomeView!
    private let model = WelcomeModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        welcomeView = WelcomeView(frame: view.bounds)
        welcomeView.delegate = self
        welcomeView.configure(with: model)
        view.addSubview(welcomeView)
    }
}


extension WelcomeController: WelcomeViewDelegate {
    func didTapLoginButton() {
        navigateToLogin()
    }
    
    private func navigateToLogin() {
        let loginViewController = LoginController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}
