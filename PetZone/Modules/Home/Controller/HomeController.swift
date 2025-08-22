import UIKit
import ParseSwift
import SpriteKit

final class HomeController: UIViewController {
    
    private let productService: ProductProtocol
    private let cartService: CartProtocol
    
    private var products: [Product] = []
    private lazy var homeView = HomeView()
    private let sideMenuWidth: CGFloat = 250
    private var sideMenu: SideMenuController!
    private var isSideMenuOpen = false
    private var tapGesture: UITapGestureRecognizer!
    
    init(productService: ProductProtocol = ProductService(),
         cartService: CartProtocol = CartService()) {
        self.productService = productService
        self.cartService = cartService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        fetchProducts()
        setupTapGesture()
    }
    
    private func setupUI() {
        setupTableView()
        setupSideMenu()
        setupNavigationBar()
    }
    
    private func setupActions() {
        homeView.setCartButtonAction(target: self, action: #selector(handleCartButtonTap))
    }
    
    private func setupTableView() {
        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
        homeView.tableView.register(ProductTableCell.self,
                                  forCellReuseIdentifier: ProductTableCell.identifier)
        homeView.tableView.rowHeight = 120
        homeView.tableView.separatorStyle = .none
    }
    
    private func setupTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideMenu))
        tapGesture.cancelsTouchesInView = false
        tapGesture.isEnabled = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupSideMenu() {
        sideMenu = SideMenuController()
        sideMenu.homeViewController = self
        
        DispatchQueue.main.async {
            let sideMenuHeight = self.view.frame.height / 3.5
            self.sideMenu.view.frame = CGRect(x: -self.sideMenuWidth, y: 0,
                                           width: self.sideMenuWidth, height: sideMenuHeight)
            
            self.sideMenu.view.layer.cornerRadius = 20
            self.sideMenu.view.layer.masksToBounds = true
            
            self.sideMenu.view.layer.shadowColor = UIColor.black.cgColor
            self.sideMenu.view.layer.shadowOpacity = 0.5
            self.sideMenu.view.layer.shadowOffset = CGSize(width: 2, height: 0)
            self.sideMenu.view.layer.shadowRadius = 5
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.addSubview(self.sideMenu.view)
            }
            
            self.addChild(self.sideMenu)
            self.sideMenu.didMove(toParent: self)
        }
    }
    
    @objc func toggleSideMenu() {
        isSideMenuOpen.toggle()
        let targetPosition = isSideMenuOpen ? 0 : -sideMenuWidth
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.sideMenu.view.frame.origin.x = CGFloat(targetPosition)
        }) { _ in
            self.tapGesture.isEnabled = self.isSideMenuOpen
        }
    }
    
    @objc private func handleTapOutsideMenu(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        
        if isSideMenuOpen {
            let menuFrame = sideMenu.view.frame
            if !menuFrame.contains(location) {
                toggleSideMenu()
            }
        }
    }
    
    private func setupNavigationBar() {
        let menuButton = UIButton(type: .system)
        menuButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        menuButton.tintColor = .white
        menuButton.backgroundColor = UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
        menuButton.layer.cornerRadius = 25
        menuButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        menuButton.addTarget(self, action: #selector(toggleSideMenu), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
    }
    
    private func fetchProducts() {
        productService.fetchProducts { [weak self] (result: Result<[Product], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self?.products = products
                    self?.homeView.tableView.reloadData()
                case .failure(let error):
                    print("Erro ao buscar produtos: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func handleCartButtonTap() {
        let cartViewController = CartController()
        cartViewController.products = products
        navigationController?.pushViewController(cartViewController, animated: true)
    }
    
    private func showProductDetails(_ product: Product) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let expirationDate = product.expirationDate != nil ?
            dateFormatter.string(from: product.expirationDate!) : "Sem expiração"
        
        let alertController = UIAlertController(
            title: product.name ?? "Detalhes do Produto",
            message: """
                Código: \(product.code ?? "N/A")
                Descrição: \(product.description ?? "N/A")
                Quantidade: \(product.quantity ?? 0)
                Categoria: \(product.category ?? "N/A")
                Validade: \(expirationDate)
                """,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    private func handleAddToCart(product: Product) {
        guard let quantity = product.quantity, quantity > 0 else {
            showAlert(title: "Produto Esgotado", message: "Este produto não está mais disponível.")
            return
        }
        
        cartService.fetchCartItem(productId: product.objectId ?? "") { [weak self] (result: Result<Cart?, Error>) in
            switch result {
            case .success(let cartItem):
                if cartItem != nil {
                    self?.cartService.updateProductQuantity(productId: product.objectId ?? "") { result in
                        DispatchQueue.main.async {
                            self?.handleCartResult(result, product: product)
                        }
                    }
                } else {
                    self?.cartService.addProductToCart(product: product) { result in
                        DispatchQueue.main.async {
                            self?.handleCartResult(result, product: product)
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Falha ao verificar carro de compras: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func handleCartResult(_ result: Result<Void, Error>, product: Product) {
        DispatchQueue.main.async {
            switch result {
            case .success:
                print("Produto \(product.name ?? "") adicionado ao carrinho.")
                self.showCartAnimation()
            case .failure(let error):
                print("Falha ao atualizar carro de compras: \(error.localizedDescription)")
            }
        }
    }
    
    private func showCartAnimation() {
        DispatchQueue.main.async {
            let skView = SKView(frame: self.view.bounds)
            skView.backgroundColor = .clear
            self.view.addSubview(skView)
            
            let scene = AnimationScene(size: skView.bounds.size)
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                skView.removeFromSuperview()
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    func updateProductQuantity(productId: String, newQuantity: Int) {
        if let index = products.firstIndex(where: { $0.objectId == productId }) {
            products[index].quantity = newQuantity
            homeView.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableCell.identifier,
                                               for: indexPath) as! ProductTableCell
        let product = products[indexPath.row]
        cell.configure(with: product)
        
        cell.onPlusButtonTapped = { [weak self] product in
            self?.handleAddToCart(product: product)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showProductDetails(products[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}
