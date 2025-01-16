import Combine

internal class HomePageViewModel {
    private let networkManager: APIClient
    private let decoder: DataDecoderProtocol
    private let urlConstructor: URLConstructorProtocol
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var cachedItem: [ItemCategoryModel]?
    private var cancellables: Set<AnyCancellable> = []

    init(contract: HomePageViewModelContract) {
        self.networkManager = contract.networkManager
        self.decoder = contract.dataDecoder
        self.urlConstructor = contract.urlConstructor
    }
}

extension HomePageViewModel: HomePageViewModelFetchProtocol {
    func fetchData() {
        isLoading = true
        let url: String = urlConstructor.constructURL()
        networkManager.get(url: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                do {
                    let str = String(decoding: data, as: UTF8.self)
                    print(str)
                    let rawData = try self.decoder.decode(RawDataModel.self, from: data)
                    self.cachedItem = rawData.data.categories
                    print("cachedItem = \(String(describing: cachedItem))" )
                } catch {
                    self.errorMessage = "Error fetching data: \(error)"
                }
            case .failure(let error):
                self.errorMessage = "Error fetching data: \(error)"
            }
            isLoading = false
        }
    }
}
