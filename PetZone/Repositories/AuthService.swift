import Foundation
import ParseSwift

class AuthService: AuthProtocol {
    static let shared = AuthService()
    private let apiClient = APIClient.shared
    
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        User.login(username: email, password: password) { [weak self] result in
            self?.apiClient.handleResponse(result, completion: completion)
        }
    }
    
    func register(name: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        var user = User()
        user.username = email
        user.email = email
        user.password = password
        user.name = name
        
        user.signup { [weak self] result in
            self?.apiClient.handleResponse(result, completion: completion)
        }
    }
    
    func recoverPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        User.passwordReset(email: email) { [weak self] result in
            self?.apiClient.handleResponse(result, completion: completion)
        }
    }
}
