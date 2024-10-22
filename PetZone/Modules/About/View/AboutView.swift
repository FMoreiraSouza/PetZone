import UIKit

final class AboutView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PetZone"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "WelcomePet")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Descrição"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.attributedText = createJustifiedText()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(descriptionTitleLabel)
        addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func createJustifiedText() -> NSAttributedString {
        let text = """
        No PetZone, acreditamos que cada pet merece cuidado e carinho especial. Nosso aplicativo conecta você ao mundo de soluções para seu pet: 
        desde serviços, cuidados, até dicas valiosas para tornar a vida do seu companheiro ainda mais feliz. Navegue com facilidade e descubra como o PetZone pode fazer parte da sua rotina de cuidado e amor!
        """
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        
        return NSAttributedString(
            string: text,
            attributes: [.paragraphStyle: paragraphStyle]
        )
    }
}
