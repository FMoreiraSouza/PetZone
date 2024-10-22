protocol HomeViewDelegate: AnyObject {
    func didTapMenuButton()
    func didTapCartButton()
    func didSelectProduct(_ product: Product)
    func didTapAddToCart(_ product: Product)
}
