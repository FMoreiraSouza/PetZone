import Foundation
import UIKit

struct WelcomeModel {
    let title: String
    let message: String
    let buttonTitle: String
    let backgroundColor: UIColor
    
    init() {
        self.title = "Bem-vindo ao PetZone"
        self.message = "Seu pet shop digital!"
        self.buttonTitle = ""
        self.backgroundColor = UIColor(red: 1, green: 0.98, blue: 0.98, alpha: 1)
    }
}
