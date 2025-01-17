import Combine

internal class ItemListPageViewModel: ItemListPageViewModelProtocol {
    internal let itemCategoryModel: ItemCategoryModel
    @Published var errorMessage: String?
    private let coordinator: Coordinator

    init(contract: ItemListPageViewModelContract) {
        self.itemCategoryModel = contract.parameters
        self.coordinator = contract.coordinator
    }

    internal func fetchData() -> [ViewItemListModel] {
        let viewItemListModel = itemCategoryModel.items.map { $0.toViewItemListModel()}
        return viewItemListModel
    }

    internal func navigateToDetail(for item: ViewItemListModel) {
        let parameters = itemCategoryModel.items.first(where: { $0.id == item.id })
        guard
            let parameters
        else {
            self.errorMessage = "No item found for \(item.title)"
            return
        }
        self.coordinator.navigate(to: .detailPage(parameters))
    }
}
