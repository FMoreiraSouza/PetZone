import UIKit

extension UIImageView {
    func loadImage(from url: String?) {
        guard let urlString = url, let url = URL(string: urlString) else {
            self.image = nil // Se a URL for nula, defina a imagem como nula
            return
        }
        
        // Configura um carregamento da imagem de forma assíncrona
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.image = nil // Se a imagem não puder ser carregada, defina como nula
                }
            }
        }
    }
}
