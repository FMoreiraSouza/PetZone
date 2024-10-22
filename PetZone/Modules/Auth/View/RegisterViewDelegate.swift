import Foundation

protocol RegisterViewDelegate: AnyObject {
    func didTapRegister(name: String?, email: String?, password: String?, confirmPassword: String?)
}
