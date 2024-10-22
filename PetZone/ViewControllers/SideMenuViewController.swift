import ParseSwift
import UIKit

class SideMenuViewController: UIViewController {
    var homeViewController: HomeViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray

        let welcomeLabel = UILabel()
        welcomeLabel.text = "Bem-vindo,"
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)

        let nameLabel = UILabel()
        nameLabel.text = User.current?.name ?? "Usuário"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)

        let about = createLabel(withText: "Sobre", action: #selector(navigateToAbout))
        view.addSubview(about)

        let logout = createLabel(withText: "Sair", action: #selector(logout))
        view.addSubview(logout)

        NSLayoutConstraint.activate([
            welcomeLabel.bottomAnchor.constraint(equalTo: about.topAnchor, constant: -30),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 5),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            about.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            about.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            logout.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logout.topAnchor.constraint(equalTo: about.bottomAnchor, constant: 16),
        ])
    }

    private func createLabel(withText text: String, action: Selector) -> UILabel {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        label.addGestureRecognizer(tapGesture)
        return label
    }

    @objc func navigateToAbout() {
        let aboutVC = AboutViewController()
        navigationController?.pushViewController(aboutVC, animated: true)
        closeSideMenu()
    }

    @objc func logout() {
        do {
            if let currentUser = User.current {
                try User.logout()
                let loginVC = LoginViewController()
                navigationController?.setViewControllers([loginVC], animated: true)
                closeSideMenu()
            }
        } catch {
            print("Erro ao sair: \(error.localizedDescription)")
        }
    }

    private func closeSideMenu() {
        if let homeVC = homeViewController {
            homeVC.toggleSideMenu()
        }
    }
}
