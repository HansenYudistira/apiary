internal class DetailPageViewModel: DetailPageViewModelProtocol {
    private let itemListModel: ItemListModel
    private let coordinator: Coordinator

    init(contract: DetailPageViewModelContract) {
        self.itemListModel = contract.parameters
        self.coordinator = contract.coordinator
    }
    
    internal func fetchUniqueTag() -> [String] {
        return Array(Set(itemListModel.details.tags)).sorted()
    }
    
    internal func fetchData() -> ItemListModel {
        return itemListModel
    }
}
