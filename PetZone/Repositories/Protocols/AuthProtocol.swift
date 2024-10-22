protocol AuthProtocol {
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func register(name: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func recoverPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void)
}
