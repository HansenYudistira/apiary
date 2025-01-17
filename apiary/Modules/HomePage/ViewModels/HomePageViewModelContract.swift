// MARK: HomePageViewModel Contract and Protocols
internal struct HomePageViewModelContract {
    internal let networkManager: APIClient
    internal let dataDecoder: DataDecoderProtocol
    internal let urlConstructor: URLConstructorProtocol
    internal let coordinator: Coordinator
}

typealias HomePageViewModelProtocol = HomePageViewModelFetchProtocol & HomePageViewModelNavigateProtocol

protocol HomePageViewModelFetchProtocol {
    func fetchData()
}

protocol HomePageViewModelNavigateProtocol {
    func navigateToItemList(for category: ViewCategoryListModel)
}
