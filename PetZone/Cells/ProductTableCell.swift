import UIKit

class ProductTableCell: UITableViewCell {

    static let identifier = "ProductTableCell"

    let productNameLabel = UILabel()
    let productPriceLabel = UILabel()
    let productImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        productNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        productPriceLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        productPriceLabel.textColor = .gray
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productPriceLabel)

        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),

            productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16), // Aumentar para 16

            productPriceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            productPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productPriceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8), // Aumentar para 8
            productPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16) // Aumentar para 16
        ])
    }


    func configure(with product: Product) {
        productNameLabel.text = product.name
        productPriceLabel.text = product.price != nil ? "$\(product.price!)" : "Preço não disponível"
        productImageView.loadImage(from: product.image?.url) // Carrega a imagem
    }
}
