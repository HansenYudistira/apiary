internal class ItemListPageViewModel {
    private let itemCategoryModel: ItemCategoryModel
    private let coordinator: Coordinator

    init(contract: ItemListPageViewModelContract) {
        self.itemCategoryModel = contract.parameters
        self.coordinator = contract.coordinator
    }
}
