import UIKit
import ParseSwift

final class SideMenuController: UIViewController {
    weak var homeViewController: HomeController?
    private lazy var sideMenuView = SideMenuView()
    
    override func loadView() {
        view = sideMenuView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        sideMenuView.configure(with: User.current?.name ?? "Usuário")
    }
    
    private func setupActions() {
        sideMenuView.aboutButtonAction = { [weak self] in
            self?.handleAboutTap()
        }
        
        sideMenuView.logoutButtonAction = { [weak self] in
            self?.handleLogoutTap()
        }
    }
    
    private func handleAboutTap() {
        let aboutVC = AboutController()
        navigationController?.pushViewController(aboutVC, animated: true)
        homeViewController?.toggleSideMenu()
    }
    
    private func handleLogoutTap() {
        AuthService.shared.logout { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let loginVC = LoginController()
                    let navController = UINavigationController(rootViewController: loginVC)
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = navController
                        window.makeKeyAndVisible()
                    }
                    
                case .failure(let error):
                    print("Erro ao sair: \(error.localizedDescription)")
                }
            }
        }
    }
}
