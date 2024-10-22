import UIKit

class CartTableCell: UITableViewCell {

    static let identifier = "CartTableCell"

    private let productDetailsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .darkGray
        label.backgroundColor = UIColor(white: 0.95, alpha: 1)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(productDetailsLabel)
        contentView.addSubview(dividerView)

        NSLayoutConstraint.activate([
            productDetailsLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 20),
            productDetailsLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -20),
            productDetailsLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 10),

            dividerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            dividerView.topAnchor.constraint(
                equalTo: productDetailsLabel.bottomAnchor, constant: 10),
            dividerView.heightAnchor.constraint(equalToConstant: 1),

            dividerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor),
        ])
    }

    func configure(with details: String) {
        productDetailsLabel.text = details
    }
}
