internal class DetailPageViewModel: DetailPageViewModelProtocol {
    private let itemListModel: ItemListModel
    private let coordinator: Coordinator

    init(contract: DetailPageViewModelContract) {
        self.itemListModel = contract.parameters
        self.coordinator = contract.coordinator
    }
    
    // fetch data of unique tag for filter purpose
    internal func fetchUniqueTag() -> [String] {
        return Array(Set(itemListModel.details.tags)).sorted()
    }
    
    // fetch all data contained in itemListModel
    internal func fetchData() -> ItemListModel {
        return itemListModel
    }
}
