internal struct DetailPageViewModelContract {
    let parameters: ItemListModel
    let coordinator: Coordinator
}

typealias DetailPageViewModelProtocol = DetailPageViewModelDataProtocol

protocol DetailPageViewModelDataProtocol {
    func fetchUniqueTag() -> [String]
}
