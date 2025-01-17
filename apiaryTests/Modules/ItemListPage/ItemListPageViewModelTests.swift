import XCTest
@testable import apiary

final class ItemListPageViewModelTests: XCTestCase {
    var viewModel: ItemListPageViewModel!
    var mockCoordinator: MockCoordinator!
    var mockCategory: ItemCategoryModel!
    
    override func setUp() {
        super.setUp()
        let details1 = ItemDetailModel(author: "Author1", published_date: "2025-01-01", tags: ["tag1", "tag2"])
        let details2 = ItemDetailModel(author: "Author2", published_date: "2025-01-02", tags: ["tag2", "tag3"])
        let item1 = ItemListModel(id: 1, title: "Item 1", description: "Description 1", image_url: "URL 1", details: details1)
        let item2 = ItemListModel(id: 2, title: "Item 2", description: "Description 2", image_url: "URL 2", details: details2)
        mockCategory = ItemCategoryModel(id: 1, name: "Test Category", items: [item1, item2])
        mockCoordinator = MockCoordinator()
        let contract = ItemListPageViewModelContract(parameters: mockCategory, coordinator: mockCoordinator)
        viewModel = ItemListPageViewModel(contract: contract)
    }
    
    override func tearDown() {
        viewModel = nil
        mockCoordinator = nil
        mockCategory = nil
        super.tearDown()
    }

    func testFetchData() {
        let data = viewModel.fetchData()
        XCTAssertEqual(data.count, 2, "fetchData should return all items which is 2")
        XCTAssertEqual(data[0].title, "Item 1", "first item should be Item 1 sorted by id")
    }

    func testFetchTitle() {
        let title = viewModel.fetchTitle()
        XCTAssertEqual(title, "Test Category")
    }

    func testFetchTags() {
        let tags = viewModel.fetchTags()
        XCTAssertEqual(tags, ["tag1", "tag2", "tag3"])
    }

    func testFetchFilteredData() {
        var filtered = viewModel.fetchFilteredData(with: "tag1", status: true)
        XCTAssertEqual(filtered.count, 1)

        filtered = viewModel.fetchFilteredData(with: "tag2", status: true)
        XCTAssertEqual(filtered.count, 2)
        
        filtered = viewModel.fetchFilteredData(with: "tag1", status: false)
        XCTAssertEqual(filtered.count, 2, "Should be returned 2 since item 1 dan 2 have tag2")
    }

    func testSearchItems() {
        let results = viewModel.searchItems(with: "Item 1")
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].title, "Item 1")
    }

    func testClearTagsFilter() {
        viewModel.clearTagsFilter()
        _ = viewModel.fetchFilteredData(with: "tag1", status: true)
        viewModel.clearTagsFilter()
        let filtered = viewModel.fetchFilteredData(with: "tag3", status: true)
        XCTAssertEqual(filtered.count, 1, "Should return 1 item filtered by 'tag3'")
    }

    func testNavigateToDetail() {
        let data = viewModel.fetchData()
        viewModel.navigateToDetail(for: data[0])

        XCTAssertTrue(mockCoordinator.navigateState)
    }
}
