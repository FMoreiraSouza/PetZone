import UIKit

protocol ProductTableCellDelegate: AnyObject {
    func didTapPlusButton(with product: Product)
}

class ProductTableCell: UITableViewCell {

    static let identifier = "ProductTableCell"

    let productNameLabel = UILabel()
    let productPriceLabel = UILabel()
    let productImageView = UIImageView()
    let plusButton = UIButton()
    let divider = UIView()

    weak var delegate: ProductTableCellDelegate?

    var product: Product?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        divider.backgroundColor = .gray
        divider.translatesAutoresizingMaskIntoConstraints = false

        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.translatesAutoresizingMaskIntoConstraints = false

        productNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        productNameLabel.numberOfLines = 0
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false

        productPriceLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        productPriceLabel.textColor = .gray
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false

        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.white, for: .normal)
        plusButton.backgroundColor = .systemGreen
        plusButton.layer.cornerRadius = 15
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.addTarget(
            self, action: #selector(plusButtonTapped), for: .touchUpInside)

        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productPriceLabel)
        contentView.addSubview(plusButton)
        contentView.addSubview(divider)

        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),

            productNameLabel.leadingAnchor.constraint(
                equalTo: productImageView.trailingAnchor, constant: 16),
            productNameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            productNameLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 32),

            productPriceLabel.leadingAnchor.constraint(
                equalTo: productImageView.trailingAnchor, constant: 16),
            productPriceLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            productPriceLabel.topAnchor.constraint(
                equalTo: productNameLabel.bottomAnchor, constant: 8),
            productPriceLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -32),

            plusButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            plusButton.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30),

            divider.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.centerYAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @objc private func plusButtonTapped() {
        guard let product = product else { return }
        delegate?.didTapPlusButton(with: product)
    }

    func configure(with product: Product) {
        self.product = product
        productNameLabel.text = product.name
        productPriceLabel.text =
            product.price != nil ? "$\(product.price!)" : "Preço não disponível"

        let imageUrlString = product.image?.url?.absoluteString
        productImageView.loadImage(from: imageUrlString)
    }

}
