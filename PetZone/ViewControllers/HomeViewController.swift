import UIKit

class HomeViewController: UIViewController {
    
    let sideMenuWidth: CGFloat = 250
    var sideMenu: SideMenuViewController!
    var isSideMenuOpen = false
    let titleLabel = UILabel() // Adicionando o UILabel para o título
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1, green: 0.98, blue: 0.98, alpha: 1)
        
        setupSideMenu()
        setupNavigationBar()
        setupTitleLabel() // Configurando o título
        setupTapGesture() // Adicionando gesto de toque
    }
    
    func setupNavigationBar() {
        // Criando o botão de menu personalizado
        let menuButton = UIButton(type: .system)
        menuButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        menuButton.tintColor = .white // Cor do ícone
        menuButton.backgroundColor = UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1) // Azul céu
        menuButton.layer.cornerRadius = 25 // Para circular
        menuButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50) // Tamanho do botão
        menuButton.addTarget(self, action: #selector(toggleSideMenu), for: .touchUpInside)
        
        // Criando um UIBarButtonItem a partir do botão personalizado
        let barButtonItem = UIBarButtonItem(customView: menuButton)
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    func setupSideMenu() {
        sideMenu = SideMenuViewController()
        sideMenu.homeViewController = self // Passando referência
        sideMenu.view.frame = CGRect(x: -sideMenuWidth, y: 0, width: sideMenuWidth, height: view.frame.height)
        // Adicionando o sideMenu à janela principal
        if let window = UIApplication.shared.windows.first {
            window.addSubview(sideMenu.view)
            sideMenu.view.layer.shadowColor = UIColor.black.cgColor
            sideMenu.view.layer.shadowOpacity = 0.5
            sideMenu.view.layer.shadowOffset = CGSize(width: -5, height: 0)
            sideMenu.view.layer.shadowRadius = 5
        }
        addChild(sideMenu)
        sideMenu.didMove(toParent: self)
    }
    
    func setupTitleLabel() {
        titleLabel.text = "PetZone"
        titleLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold) // Estilizando o título
        titleLabel.textColor = UIColor.black // Cor do texto
        titleLabel.translatesAutoresizingMaskIntoConstraints = false // Usando Auto Layout

        // Adicionando o titleLabel à view
        view.addSubview(titleLabel)
        
        // Ajustando as restrições para o titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8), // Usando safeAreaLayoutGuide
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSideMenu))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func toggleSideMenu() {
        isSideMenuOpen.toggle()
        
        let targetPosition = isSideMenuOpen ? 0 : -sideMenuWidth
        
        UIView.animate(withDuration: 0.3) {
            self.sideMenu.view.frame.origin.x = CGFloat(targetPosition)
        }
    }
    
    @objc func dismissSideMenu() {
        if isSideMenuOpen {
            toggleSideMenu()
        }
    }
}
