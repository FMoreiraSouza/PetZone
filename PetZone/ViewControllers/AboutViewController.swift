import UIKit

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "PetZone"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "WelcomePet")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let descriptionLabelTitle = UILabel()
        descriptionLabelTitle.text = "Descrição"
        descriptionLabelTitle.font = UIFont.boldSystemFont(ofSize: 20)
        descriptionLabelTitle.textAlignment = .center
        descriptionLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabelTitle)
        
        let descriptionLabel = UILabel()
        descriptionLabel.attributedText = createJustifiedText(
            text: """
            No PetZone, acreditamos que cada pet merece cuidado e carinho especial. Nosso aplicativo conecta você ao mundo de soluções para seu pet: 
            desde serviços, cuidados, até dicas valiosas para tornar a vida do seu companheiro ainda mais feliz. Navegue com facilidade e descubra como o PetZone pode fazer parte da sua rotina de cuidado e amor!
            """
        )
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            descriptionLabelTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionLabelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionLabelTitle.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func createJustifiedText(text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
