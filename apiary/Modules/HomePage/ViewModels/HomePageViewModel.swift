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

extension HomePageViewModel: HomePageViewModelFetchProtocol {
    func fetchData() {
        isLoading = true
//        let url: String = urlConstructor.constructURL()
        let mockData: String = """
            {
                "status": "success",
                "data": {
                "categories": [
                    {
                        "id": 101,
                        "name": "Category 1",
                        "items": [
                            {
                                "id": 1,
                                "title": "Item 1",
                                "description": "This is the description for item 1.",
                                "image_url": "https://example.com/image1.jpg",
                                "details": {
                                    "author": "Author 1",
                                    "published_date": "2024-01-10",
                                    "tags": ["tag1", "tag2", "tag3"]
                                }
                            },
                            {
                                "id": 2,
                                "title": "Item 2",
                                "description": "This is the description for item 2.",
                                "image_url": "https://example.com/image2.jpg",
                                "details": {
                                    "author": "Author 2",
                                    "published_date": "2024-01-12",
                                    "tags": ["tag4", "tag5"]
                                }
                            }
                        ]
                    },
                    {
                        "id": 102,
                        "name": "Category 2",
                        "items": [
                            {
                                "id": 3,
                                "title": "Item 3",
                                "description": "This is the description for item 3.",
                                "image_url": "https://example.com/image3.jpg",
                                "details": {
                                    "author": "Author 3",
                                    "published_date": "2024-01-15",
                                    "tags": ["tag6", "tag7", "tag8"]
                                }
                            },
                            {
                                "id": 4,
                                "title": "Item 4",
                                "description": "This is the description for item 4.",
                                "image_url": "https://example.com/image4.jpg",
                                "details": {
                                    "author": "Author 4",
                                    "published_date": "2024-01-18",
                                    "tags": ["tag9", "tag10"]
                                }
                            }
                        ]
                    }
                ]
                },
                "metadata": {
                    "total_categories": 2,
                    "total_items": 4,
                    "request_time": "2024-01-15T12:00:00Z"
                }
            }
        """
        let data = mockData.data(using: .utf8)!
        /// decode data to RawDataModel
        do {
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
            self.errorMessage = "Error decoding data: \(error)"
        }
        isLoading = false
//        networkManager.get(url: url) { [weak self] result in
//            guard let self else { return }
//            switch result {
//            case .success(let data):
//                do {
//                    /// decode data to RawDataModel
//                    let rawData = try self.decoder.decode(RawDataModel.self, from: data)
//                    /// cached categories data to cachedItem
//                    self.cachedItem = rawData.data.categories
//                    /// change ItemCategoryModel to ViewCategoryListModel to be used for view
//                    guard
//                        let cachedItem = self.cachedItem
//                    else {
//                        self.errorMessage = "Error fetching data: No categories found"
//                        return
//                    }
//                    self.categoryListModel = cachedItem.map { $0.toViewCategoryListModel() }
//                } catch {
//                    self.errorMessage = "Error fetching data: \(error)"
//                }
//            case .failure(let error):
//                self.errorMessage = "Error fetching data: \(error)"
//            }
//            /// hide loading from view
//            isLoading = false
//        }
    }
}

extension HomePageViewModel: HomePageViewModelNavigateProtocol {
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
