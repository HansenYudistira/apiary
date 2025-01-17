import Combine

internal class HomePageViewModel {
    private let networkManager: APIClient
    private let decoder: DataDecoderProtocol
    private let urlConstructor: URLConstructorProtocol
    private let coordinator: Coordinator
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var cachedItem: [ItemCategoryModel]?
    @Published var categoryListModel: [ViewCategoryListModel]?
    private var cancellables: Set<AnyCancellable> = []

    init(contract: HomePageViewModelContract) {
        self.networkManager = contract.networkManager
        self.decoder = contract.dataDecoder
        self.urlConstructor = contract.urlConstructor
        self.coordinator = contract.coordinator
    }
}

// MARK: View Model Fetching Data Protocol
extension HomePageViewModel: HomePageViewModelFetchProtocol {
    func fetchData() {
        /// make View show loading
        isLoading = true
        /// Constructing URL with URLConstructor
        let url: String = urlConstructor.constructURL()
        /// Calling NetworkManager get function to fetch data from API
        networkManager.get(url: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                do {
                    /// decode data to RawDataModel
                    let rawData = try self.decoder.decode(RawDataModel.self, from: data)
                    /// cached categories data to cachedItem
                    self.cachedItem = rawData.data.categories
                    /// change ItemCategoryModel to ViewCategoryListModel to be used for view
                    guard
                        let cachedItem = self.cachedItem
                    else {
                        self.errorMessage = "Error fetching data: No categories found"
                        return
                    }
                    self.categoryListModel = cachedItem.map { $0.toViewCategoryListModel() }
                } catch {
                    self.errorMessage = "Error fetching data: \(error)"
                }
            case .failure(let error):
                self.errorMessage = "Error fetching data: \(error)"
            }
            /// hide loading from view
            isLoading = false
        }
    }
}

// MARK: View Model Navigate Protocol
extension HomePageViewModel: HomePageViewModelNavigateProtocol {
    // function for navigate to Item List based on chosen category
    internal func navigateToItemList(for category: ViewCategoryListModel) {
        let parameters = cachedItem?.first(where: { $0.id == category.id })
        guard
            let parameters
        else {
            self.errorMessage = "No item found for \(category.name)"
            return
        }
        self.coordinator.navigate(to: .itemListPage(parameters))
    }
}
