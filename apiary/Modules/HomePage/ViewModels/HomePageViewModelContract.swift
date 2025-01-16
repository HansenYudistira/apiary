internal struct HomePageViewModelContract {
    internal let networkManager: APIClient
    internal let dataDecoder: DataDecoderProtocol
    internal let urlConstructor: URLConstructorProtocol
}

typealias HomePageViewModelProtocol = HomePageViewModelFetchProtocol

protocol HomePageViewModelFetchProtocol {
    func fetchData()
}
