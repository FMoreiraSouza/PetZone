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
    }
    
    private func setupSideMenu() {
        sideMenu = SideMenuController()
        sideMenu.homeViewController = self
        let sideMenuHeight = view.frame.height / 3.5
        sideMenu.view.frame = CGRect(x: -sideMenuWidth, y: 0,
                                   width: sideMenuWidth, height: sideMenuHeight)
        sideMenu.view.layer.cornerRadius = 20
        sideMenu.view.layer.masksToBounds = true
        
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
        productService.fetchProducts { [weak self] (result: Result<[Product], ParseError>) in
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
    
    @objc func toggleSideMenu() {
        isSideMenuOpen.toggle()
        let targetPosition = isSideMenuOpen ? 0 : -sideMenuWidth
        
        UIView.animate(withDuration: 0.3) {
            self.sideMenu.view.frame.origin.x = CGFloat(targetPosition)
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
    
    private func showCartAnimation() {
        let skView = SKView(frame: view.bounds)
        skView.backgroundColor = .clear
        view.addSubview(skView)
        
        let scene = CartAnimationScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            skView.removeFromSuperview()
        }
    }
    
    private func handleCartResult(_ result: Result<Void, ParseError>, product: Product) {
        switch result {
        case .success:
            print("Produto \(product.name ?? "") adicionado ao carrinho.")
            showCartAnimation()
        case .failure(let error):
            print("Falha ao atualizar carrinho: \(error.localizedDescription)")
        }
    }
    
    private func handleAddToCart(product: Product) {
        cartService.fetchCartItem(productId: product.objectId ?? "") { [weak self] (result: Result<Cart?, ParseError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let cartItem):
                    if cartItem != nil {
                        self?.cartService.updateProductQuantity(productId: product.objectId ?? "") { result in
                            self?.handleCartResult(result, product: product)
                        }
                    } else {
                        self?.cartService.addProductToCart(product: product) { result in
                            self?.handleCartResult(result, product: product)
                        }
                    }
                case .failure(let error):
                    print("Falha ao verificar carrinho: \(error.localizedDescription)")
                }
            }
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
}
