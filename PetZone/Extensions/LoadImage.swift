import UIKit

extension UIImageView {
    private static var taskKey = 0
    private static var urlKey = 0
    
    private var currentTask: URLSessionTask? {
        get { objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var currentURL: URL? {
        get { objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func loadImage(from urlString: String?) {
        currentTask?.cancel()
        currentTask = nil
        
        self.image = nil
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        currentURL = url
        
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            self.image = cachedImage
            return
        }
        
        currentTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                return
            }
            
            guard let data = data, let downloadedImage = UIImage(data: data), error == nil else {
                return
            }
            
            ImageCache.shared.setImage(downloadedImage, forKey: urlString)
            
            if self.currentURL == url {
                DispatchQueue.main.async {
                    self.image = downloadedImage
                }
            }
        }
        
        currentTask?.resume()
    }
    
    func cancelImageLoad() {
        currentTask?.cancel()
        currentTask = nil
    }
}

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
