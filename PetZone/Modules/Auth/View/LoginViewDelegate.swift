import UIKit

protocol LoginViewDelegate: AnyObject {
    func didTapLogin(email: String?, password: String?)
    func didTapRegister()
    func didTapForgotPassword(email: String?)
}
