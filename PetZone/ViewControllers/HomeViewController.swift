import ParseSwift
import SpriteKit
import UIKit

class HomeViewController: UIViewController, UITableViewDelegate,
    UITableViewDataSource, ProductTableCellDelegate
{

    let sideMenuWidth: CGFloat = 250
    var sideMenu: SideMenuViewController!
    var isSideMenuOpen = false
    let titleLabel = UILabel()
    let cartService = CartService()

    let tableView = UITableView()
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(
            red: 1, green: 0.98, blue: 0.98, alpha: 1)

        setupSideMenu()
        setupNavigationBar()
        setupTitleLabel()
        setupTapGesture()
        setupTableView()
        fetchProducts()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            ProductTableCell.self,
            forCellReuseIdentifier: ProductTableCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func fetchProducts() {
        let productService = ProductService()
        productService.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
                self?.tableView.reloadData()
            case .failure(let error):
                print("Erro ao buscar produtos: \(error.localizedDescription)")
            }
        }
    }

    func showCartAnimation() {
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

    func didTapPlusButton(with product: Product) {
        if let index = cart.firstIndex(where: { $0.id == product.id }) {

            cart[index].quantity! += 1

            updateProductInBack4App(productId: product.objectId ?? "")
        } else {

            var newProduct = product
            newProduct.quantity = 1
            cart.append(newProduct)

            saveProductToBack4App(
                productId: product.objectId ?? "",
                name: product.name ?? "",
                price: product.price ?? 0.0,
                quantity: 1
            )
        }

        print("Produto \(product.name ?? "") adicionado ao carrinho.")

        showCartAnimation()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: ProductTableCell.identifier, for: indexPath)
            as! ProductTableCell
        let product = products[indexPath.row]
        cell.configure(with: product)
        cell.delegate = self
        return cell
    }

    var cart: [Product] = []

    func updateProductInBack4App(productId: String) {

        let query = Cart.query()
        query.find { result in
            switch result {
            case .success(let results):

                if var existingCart = results.first(where: {
                    $0.productId!.objectId == productId
                }) {

                    existingCart.quantity = existingCart.quantity! + 1

                    existingCart.save { saveResult in
                        switch saveResult {
                        case .success:
                            print(
                                "Quantidade atualizada com sucesso no Back4App!"
                            )
                        case .failure(let error):
                            print(
                                "Falha ao atualizar a quantidade: \(error.localizedDescription)"
                            )
                        }
                    }
                } else {
                    print("Produto não encontrado no carrinho.")
                }
            case .failure(let error):
                print(
                    "Falha ao buscar produtos no Back4App: \(error.localizedDescription)"
                )
            }
        }
    }

    func saveProductToBack4App(
        productId: String, name: String, price: Double, quantity: Int32
    ) {
        var cart = Cart()

        cart.name = name
        cart.price = price
        cart.quantity = Int(quantity)
        let productPointer = Pointer<Product>(objectId: productId)
        cart.productId = productPointer

        cart.save { result in
            switch result {
            case .success:
                print("Produto salvo com sucesso no Back4App!")
            case .failure(let error):
                print(
                    "Falha ao salvar o produto: \(error.localizedDescription)")
            }
        }

    }

    func fetchCartItem(
        productId: String, completion: @escaping (Result<Cart?, Error>) -> Void
    ) {
        let query = Cart.query

        query.find { result in
            switch result {
            case .success(let items):
                if let cartItem = items.first {
                    print("Item encontrado: \(cartItem)")
                    completion(.success(cartItem))
                } else {
                    print(
                        "Nenhum item encontrado com o productId: \(productId)")
                    completion(.success(nil))
                }
            case .failure(let error):
                print(
                    "Falha ao buscar item do carrinho: \(error.localizedDescription)"
                )
                completion(.failure(error))
            }
        }
    }

    
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        let product = products[indexPath.row]

    
        showProductDetails(product: product)

    
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    func showProductDetails(product: Product) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let expirationDate =
            product.expirationDate != nil
            ? dateFormatter.string(from: product.expirationDate!)
            : "Sem expiração"

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

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }

    func setupNavigationBar() {
        let menuButton = UIButton(type: .system)
        menuButton.setImage(
            UIImage(systemName: "line.horizontal.3"), for: .normal)
        menuButton.tintColor = .white
        menuButton.backgroundColor = UIColor(
            red: 135 / 255, green: 206 / 255, blue: 250 / 255, alpha: 1)
        menuButton.layer.cornerRadius = 25
        menuButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        menuButton.addTarget(
            self, action: #selector(toggleSideMenu), for: .touchUpInside)

        let barButtonItem = UIBarButtonItem(customView: menuButton)
        self.navigationItem.leftBarButtonItem = barButtonItem
    }

    func setupSideMenu() {
        sideMenu = SideMenuViewController()
        sideMenu.homeViewController = self

        let sideMenuWidth: CGFloat = 200

        let sideMenuHeight = view.frame.height / 3.5

        sideMenu.view.frame = CGRect(
            x: -sideMenuWidth, y: 0, width: sideMenuWidth,
            height: sideMenuHeight
        )

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

    func setupTitleLabel() {

        titleLabel.text = "PetZone"
        titleLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        titleLabel.textColor = UIColor.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let cartIcon = UIImageView()
        cartIcon.image = UIImage(systemName: "cart.fill")
        cartIcon.tintColor = UIColor(
            red: 135 / 255, green: 206 / 255, blue: 250 / 255, alpha: 1)
        cartIcon.translatesAutoresizingMaskIntoConstraints = false
        cartIcon.contentMode = .scaleAspectFit
        cartIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cartIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let cartTapGesture = UITapGestureRecognizer(
            target: self, action: #selector(cartIconTapped))
        cartIcon.isUserInteractionEnabled = true
        cartIcon.addGestureRecognizer(cartTapGesture)

        let titleStackView = UIStackView(arrangedSubviews: [
            titleLabel, cartIcon,
        ])
        titleStackView.axis = .horizontal
        titleStackView.spacing = 8
        titleStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleStackView)

        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16),
            titleStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    @objc func cartIconTapped() {

        let cartViewController = CartViewController()

        cartViewController.products = products

        navigationController?.pushViewController(
            cartViewController, animated: true)
    }

    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self, action: #selector(dismissSideMenu))
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
