import Combine

internal class ItemListPageViewModel: ItemListPageViewModelProtocol {
    internal let itemCategoryModel: ItemCategoryModel
    private let coordinator: Coordinator

    init(contract: ItemListPageViewModelContract) {
        self.itemCategoryModel = contract.parameters
        self.coordinator = contract.coordinator
    }

    internal func fetchData() -> [ViewItemListModel] {
        let viewItemListModel = itemCategoryModel.items.map { $0.toViewItemListModel()}
        return viewItemListModel
    }

    internal func navigateToDetail(for item: ItemCategoryModel) {
        
    }
}
