import Foundation
import ParseSwift

class AuthService {

    static let shared = AuthService()

    private init() {}

    // Método para registrar o usuário
    func registerUser(
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
                print(
                    "Erro ao registrar o usuário: \(error.localizedDescription)"
                )
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
