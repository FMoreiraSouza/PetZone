import UIKit

extension UIImageView {
    func loadImage(from url: String?) {
        guard let urlString = url, let url = URL(string: urlString) else {
            self.image = nil
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.image = nil
                }
            }
        }
    }
}
