internal struct ItemListPageViewModelContract {
    let parameters: ItemCategoryModel
    let coordinator: Coordinator
}

typealias ItemListPageViewModelProtocol =
ItemListPageViewModelFetchProtocol &
ItemListPageViewModelNavigateProtocol

protocol ItemListPageViewModelFetchProtocol {
    func fetchData() -> [ViewItemListModel]
    func fetchTitle() -> String
}

protocol ItemListPageViewModelNavigateProtocol {
    func navigateToDetail(for item: ViewItemListModel)
}
