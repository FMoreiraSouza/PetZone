import Foundation
import ParseSwift

class AuthService {

    static let shared = AuthService()

    private init() {}

    func registerUser(
        name: String, email: String, password: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        if let currentUser = User.current {
            User.logout { result in
                switch result {
                case .success:
                    print("Usuário anterior deslogado com sucesso.")
                    self.createNewUser(name: name, email: email, password: password, completion: completion)
                case .failure(let error as NSError):
                    if error.code == 209 {
                        print("Token de sessão inválido. Limpando sessão.")
                        self.createNewUser(name: name, email: email, password: password, completion: completion)
                    } else {
                        print("Erro ao deslogar usuário anterior: \(error.localizedDescription)")
                        completion(false, error)
                    }
                }
            }
        } else {
            createNewUser(name: name, email: email, password: password, completion: completion)
        }
    }

    private func createNewUser(
        name: String, email: String, password: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        var user = User()
        user.username = email
        user.email = email
        user.password = password
        user.name = name

        user.signup { result in
            switch result {
            case .success(let user):
                print("Usuário registrado com sucesso: \(user)")
                completion(true, nil)
            case .failure(let error):
                print("Erro ao registrar o usuário: \(error.localizedDescription)")
                completion(false, error)
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        User.login(username: email, password: password) { result in
            switch result {
            case .success(let user):
                print("Usuário logado com sucesso: \(user)")
                completion(true, nil)
            case .failure(let error):
                print("Erro ao logar o usuário: \(error.localizedDescription)")
                completion(false, error)
            }
        }
    }
    
    func recoverPassword(email: String, completion: @escaping (Bool, Error?) -> Void) {
        User.passwordReset(email: email) { result in
            switch result {
            case .success:
                print("E-mail de recuperação enviado para: \(email)")
                completion(true, nil)
            case .failure(let error):
                print("Erro ao enviar e-mail de recuperação: \(error.localizedDescription)")
                completion(false, error)
            }
        }
    }
}
