internal class DetailPageViewModel: DetailPageViewModelProtocol {
    private let itemListModel: ItemListModel
    private let coordinator: Coordinator

    init(contract: DetailPageViewModelContract) {
        self.itemListModel = contract.parameters
        self.coordinator = contract.coordinator
    }
}
