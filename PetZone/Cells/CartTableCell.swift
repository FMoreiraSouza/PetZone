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
        view.backgroundColor = .lightGray // Cor do divisor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Closure to handle quantity change
    var onQuantityChange: ((Int) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(productDetailsLabel)
        contentView.addSubview(dividerView) // Adiciona o divisor à célula

        NSLayoutConstraint.activate([
            productDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            productDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            productDetailsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            // Define a posição do divisor abaixo do label
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dividerView.topAnchor.constraint(equalTo: productDetailsLabel.bottomAnchor, constant: 10), // Espaçamento entre o label e o divisor
            dividerView.heightAnchor.constraint(equalToConstant: 1), // Altura do divisor

            dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor) // O divisor vai até a parte inferior da célula
        ])
    }

    // MARK: - Funções para aumentar ou diminuir a quantidade
    @objc private func decreaseQuantity() {
        onQuantityChange?(-1)  // Chama a closure com -1 para diminuir
    }

    @objc private func increaseQuantity() {
        onQuantityChange?(1)  // Chama a closure com +1 para aumentar
    }

    // MARK: - Função para configurar a célula com detalhes do produto
    func configure(with details: String) {
        productDetailsLabel.text = details
    }
}
