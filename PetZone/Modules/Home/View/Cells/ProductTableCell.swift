import UIKit

final class ProductTableCell: UITableViewCell {
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let soldOutLabel: UILabel = {
        let label = UILabel()
        label.text = "ESGOTADO"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .red
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static let identifier = "ProductTableCell"
    var onPlusButtonTapped: ((Product) -> Void)?
    private var product: Product?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupActions()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productPriceLabel)
        contentView.addSubview(plusButton)
        contentView.addSubview(soldOutLabel)
        contentView.addSubview(divider)
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            
            productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            productNameLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            productPriceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            productPriceLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            productPriceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
            productPriceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30),
            
            soldOutLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            soldOutLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            soldOutLabel.widthAnchor.constraint(equalToConstant: 80),
            soldOutLabel.heightAnchor.constraint(equalToConstant: 25),
            
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupActions() {
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
          super.prepareForReuse()
          
          productImageView.cancelImageLoad()
          productImageView.image = nil
          
          soldOutLabel.isHidden = true
          plusButton.isHidden = false
          productNameLabel.textColor = .black
          productPriceLabel.textColor = .gray
      }
      
      func configure(with product: Product) {
          self.product = product
          productNameLabel.text = product.name
          productPriceLabel.text = formatPrice(product.price)
          
          if let imageUrl = product.image?.url?.absoluteString {
              productImageView.loadImage(from: imageUrl)
          } else {
              productImageView.image = nil
          }
          
          if let quantity = product.quantity, quantity <= 0 {
              soldOutLabel.isHidden = false
              plusButton.isHidden = true
              productNameLabel.textColor = .lightGray
              productPriceLabel.textColor = .lightGray
          } else {
              soldOutLabel.isHidden = true
              plusButton.isHidden = false
              productNameLabel.textColor = .black
              productPriceLabel.textColor = .gray
          }
      }
    
    private func formatPrice(_ price: Double?) -> String {
        guard let price = price else { return "Preço não disponível" }
        return String(format: "R$ %.2f", price)
    }
    
    @objc private func plusButtonTapped() {
        guard let product = product else { return }
        DispatchQueue.main.async {
            self.onPlusButtonTapped?(product)
        }
    }
}
