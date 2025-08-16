import UIKit
import ParseSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        if User.current != nil {
            window?.rootViewController = UINavigationController(rootViewController: HomeController())
        } else {
            window?.rootViewController = UINavigationController(rootViewController: WelcomeController())
        }
        
        window?.makeKeyAndVisible()
    }
}
