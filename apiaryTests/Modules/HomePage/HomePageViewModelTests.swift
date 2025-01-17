import Combine
import XCTest
@testable import apiary

final class MockNetworkManager: APIClient {
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

    enum MockDataError: Error {
        case failedToConvertData
    }

    func get(url: String, completion: @escaping (Result<Data, any Error>) -> Void) {
        if let data = mockData.data(using: .utf8) {
            completion(.success(data))
        } else {
            completion(.failure(MockDataError.failedToConvertData))
        }
    }
}

struct MockURLConstructor: URLConstructorProtocol {
    func constructURL() -> String {
        return "Test"
    }
}

class MockCoordinator: Coordinator {
    var startState: Bool = false
    var navigateState: Bool = false
    func start() {
        startState = true
    }
    
    func navigate(to destination: apiary.Destination) {
        navigateState = true
    }
}

final class HomePageViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    var viewModel: HomePageViewModel!
    var coordinator: MockCoordinator!

    override func setUp() {
        super.setUp()
        cancellables = []
        coordinator = MockCoordinator()
        let contract = HomePageViewModelContract(
            networkManager: MockNetworkManager(),
            dataDecoder: DataDecoder(),
            urlConstructor: MockURLConstructor(),
            coordinator: coordinator
        )
        viewModel = HomePageViewModel(contract: contract)
    }

    override func tearDown() {
        cancellables = []
        super.tearDown()
    }

    func testSuccessConvertDataToModel() {
        let expectation = self.expectation(description: "Should success convert the data into model")
        viewModel.$cachedItem
            .sink { category in
                guard let category else { return }
                XCTAssertEqual(category.count, 2)
                XCTAssertEqual(category[0].name, "Category 1")
                XCTAssertEqual(category[1].items[0].description, "This is the description for item 3.")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.fetchData()
        waitForExpectations(timeout: 2.0, handler: nil)
        cancellables = []
    }
    
    func testNavigateToItemListSuccess() {
        viewModel.fetchData()
        let category = ViewCategoryListModel(id: 101, name: "Category 1", item_count: 1)
        viewModel.navigateToItemList(for: category)
        XCTAssertTrue(coordinator.navigateState)
    }

    func testNavigateToItemListFailed() {
        viewModel.fetchData()
        let category = ViewCategoryListModel(id: -1, name: "Category 1", item_count: 1)
        viewModel.navigateToItemList(for: category)
        XCTAssertFalse(coordinator.navigateState)
    }
}
