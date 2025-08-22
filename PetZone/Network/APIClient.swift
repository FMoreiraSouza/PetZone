import ParseSwift
import Foundation

class APIClient {
    static let shared = APIClient()
    
    private init() {
        setupParse()
    }
    
    private func setupParse() {
        ParseSwift.initialize(
            applicationId: "H22BV9kcM24RJivNHcGuyTPtJea0wc9LDXnrZ0F3",
            clientKey: "hZHhr6qbPcSOQ1RoninUNI6k0cH7XEV77jm3vR1g",
            serverURL: URL(string: "https://parseapi.back4app.com")!
        )
    }
    
    func handleResponse<T>(_ result: Result<T, ParseError>, 
                          completion: @escaping (Result<T, Error>) -> Void) {
        switch result {
        case .success(let value):
            completion(.success(value))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
