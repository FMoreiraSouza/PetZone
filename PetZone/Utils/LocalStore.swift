import Foundation

class LocalStore {

    static let shared = LocalStore()

    private let defaults = UserDefaults.standard

    func saveProductIds(_ productIds: [String]) {
        defaults.set(productIds, forKey: "productIds")
    }

    func getProductIds() -> [String]? {
        return defaults.stringArray(forKey: "productIds")
    }

    func addProductId(_ productId: String) {
        var productIds = getProductIds() ?? []
        if !productIds.contains(productId) {
            productIds.append(productId)
            saveProductIds(productIds)
        }
    }

    func containsProductId(_ productId: String) -> Bool {
        let productIds = getProductIds() ?? []
        return productIds.contains(productId)
    }

    func removeProductId(_ productId: String) {
        var productIds = getProductIds() ?? []
        if let index = productIds.firstIndex(of: productId) {
            productIds.remove(at: index)
            saveProductIds(productIds)
        }
    }

    func clearProductIds() {
        defaults.removeObject(forKey: "productIds")
    }
}
