internal struct ItemListPageViewModelContract {
    let parameters: ItemCategoryModel
    let coordinator: Coordinator
}

typealias ItemListPageViewModelProtocol =
ItemListPageViewModelDataProtocol &
ItemListPageViewModelNavigateProtocol

protocol ItemListPageViewModelDataProtocol {
    func fetchData() -> [ViewItemListModel]
    func fetchTitle() -> String
    func fetchTags() -> [String]
    func fetchFilteredData(with tag: String, status: Bool) -> [ViewItemListModel]
    func searchItems(with query: String) -> [ViewItemListModel]
    func clearTagsFilter()
}

protocol ItemListPageViewModelNavigateProtocol {
    func navigateToDetail(for item: ViewItemListModel)
}
