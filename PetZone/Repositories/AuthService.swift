import Foundation
import ParseSwift

class AuthService: AuthProtocol {
    static let shared = AuthService()
    private let apiClient = APIClient.shared
    
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        User.login(username: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func register(name: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        var user = User()
        user.username = email
        user.email = email
        user.password = password            
        user.name = name
        
        user.signup { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func recoverPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        User.passwordReset(email: email) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        User.logout { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
