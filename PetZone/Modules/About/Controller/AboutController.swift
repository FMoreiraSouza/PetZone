import UIKit

final class AboutController: UIViewController {
        private lazy var aboutView = AboutView()
    
    override func loadView() {
        view = aboutView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
