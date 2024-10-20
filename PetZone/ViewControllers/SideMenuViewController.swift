import UIKit

class SideMenuViewController: UIViewController {
    var homeViewController: HomeViewController? // Referência para o HomeViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray

        let about = createLabel(withText: "Sobre", action: #selector(navigateToAbout))
        view.addSubview(about)

        let myOrders = createLabel(withText: "Meus pedidos", action: #selector(navigateToOrders))
        view.addSubview(myOrders)

        let logout = createLabel(withText: "Sair", action: #selector(logout))
        view.addSubview(logout)

        // Definindo as constraints
        NSLayoutConstraint.activate([
            // Label "Sobre Lateral"
            about.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            about.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            // Label "Meus pedidos"
            myOrders.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            myOrders.topAnchor.constraint(equalTo: about.bottomAnchor, constant: 16),

            // Label "Sair Lateral"
            logout.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logout.topAnchor.constraint(equalTo: myOrders.bottomAnchor, constant: 16)
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

    @objc func navigateToOrders() {
        let ordersVC = OrdersViewController()
        navigationController?.pushViewController(ordersVC, animated: true)
        closeSideMenu()
    }

    @objc func logout() {
        let loginVC = LoginViewController()
        navigationController?.setViewControllers([loginVC], animated: true)
        closeSideMenu()
    }

    private func closeSideMenu() {
        if let homeVC = homeViewController {
            homeVC.toggleSideMenu()
        }
    }
}
