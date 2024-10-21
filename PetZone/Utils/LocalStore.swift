import Foundation

class LocalStore {

    static let shared = LocalStore() // Singleton para acesso global

    private let defaults = UserDefaults.standard
    
    // Função para salvar um array de Strings
    func saveProductIds(_ productIds: [String]) {
        defaults.set(productIds, forKey: "productIds")
    }

    // Função para recuperar o array de Strings salvo
    func getProductIds() -> [String]? {
        return defaults.stringArray(forKey: "productIds")
    }

    // Função para adicionar um productId ao array existente
    func addProductId(_ productId: String) {
        var productIds = getProductIds() ?? []
        if !productIds.contains(productId) {
            productIds.append(productId)
            saveProductIds(productIds)
        }
    }

    // Função para verificar se o productId já está salvo
    func containsProductId(_ productId: String) -> Bool {
        let productIds = getProductIds() ?? []
        return productIds.contains(productId)
    }

    // Função para remover um productId específico
    func removeProductId(_ productId: String) {
        var productIds = getProductIds() ?? []
        if let index = productIds.firstIndex(of: productId) {
            productIds.remove(at: index)
            saveProductIds(productIds)
        }
    }

    // Função para limpar todos os productIds
    func clearProductIds() {
        defaults.removeObject(forKey: "productIds")
    }
}
