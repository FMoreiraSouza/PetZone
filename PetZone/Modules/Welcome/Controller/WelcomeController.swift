import UIKit

class WelcomeController: UIViewController {
    
    private var welcomeView: WelcomeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        welcomeView = WelcomeView(frame: view.bounds)
        welcomeView.onLoginButtonTapped = { [weak self] in
            self?.navigateToLogin()
        }
        view.addSubview(welcomeView)
    }
    
    private func navigateToLogin() {
        let loginViewController = LoginController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}
