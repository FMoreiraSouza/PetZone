import ParseSwift
import UIKit

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
        closeSideMenu()
    }
    
    private func handleLogoutTap() {
        do {
            if let currentUser = User.current {
                try User.logout()
                let loginVC = LoginController()
                navigationController?.setViewControllers([loginVC], animated: true)
                closeSideMenu()
            }
        } catch {
            print("Erro ao sair: \(error.localizedDescription)")
        }
    }
    
    private func closeSideMenu() {
        homeViewController?.toggleSideMenu()
    }
}
