import Foundation
import ParseSwift

class AuthService {

    static let shared = AuthService()

    private init() {}

    func registerUser(
        name: String, email: String, password: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        // Verificar se já existe um usuário logado
        if let currentUser = User.current {
            // Tentar deslogar o usuário atual
            User.logout { result in
                switch result {
                case .success:
                    print("Usuário anterior deslogado com sucesso.")
                    self.createNewUser(name: name, email: email, password: password, completion: completion)
                case .failure(let error as NSError):
                    if error.code == 209 {
                        // Se o token de sessão for inválido, limpamos o usuário local
                        print("Token de sessão inválido. Limpando sessão.")
                        // Aqui você deve chamar um método que redefine o estado do usuário local
                        // Se você não tiver um método específico, você pode simplesmente
                        // não fazer nada e continuar com o registro
                        self.createNewUser(name: name, email: email, password: password, completion: completion)
                    } else {
                        print("Erro ao deslogar usuário anterior: \(error.localizedDescription)")
                        completion(false, error)
                    }
                }
            }
        } else {
            // Se não houver um usuário logado, criar novo diretamente
            createNewUser(name: name, email: email, password: password, completion: completion)
        }
    }

    // Método auxiliar para criar o novo usuário
    private func createNewUser(
        name: String, email: String, password: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        var user = User()
        user.username = email
        user.email = email
        user.password = password
        user.name = name  // Campo personalizado

        // Método para fazer o registro
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



    
    // Método para login de usuário
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
    
    // Método para recuperação de senha
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

// Subclasse que conforma com ParseUser e protocolos Codable
struct User: ParseUser, Codable {
    var emailVerified: Bool?

    var authData: [String: [String: String]?]?

    var originalData: Data?

    // Campos obrigatórios de ParseUser
    var objectId: String?
    var username: String?
    var email: String?
    var password: String?

    // Campo personalizado
    var name: String?

    // Campos obrigatórios de ParseObject
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    init() {}
}
