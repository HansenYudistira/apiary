import XCTest
@testable import apiary

final class DetailPageViewModelTests: XCTestCase {
    var viewModel: DetailPageViewModel!
    var mockCoordinator: MockCoordinator!
    var mockItemListModel: ItemListModel!
    
    override func setUp() {
        super.setUp()
        let mockDetails = ItemDetailModel(author: "author", published_date: "now", tags: ["tag1", "tag2", "tag2", "tag3"])
        mockItemListModel = ItemListModel(id: 1, title: "Test Item", description: "Test Description", image_url: "test", details: mockDetails)
        mockCoordinator = MockCoordinator()

        let contract = DetailPageViewModelContract(parameters: mockItemListModel, coordinator: mockCoordinator)
        viewModel = DetailPageViewModel(contract: contract)
    }

    override func tearDown() {
        viewModel = nil
        mockCoordinator = nil
        mockItemListModel = nil
        super.tearDown()
    }
    
    func testUniqueTags() {
        let tags = viewModel.fetchUniqueTag()
        XCTAssertEqual(tags.count, 3)
        XCTAssertEqual(tags, ["tag1", "tag2", "tag3"])
    }
    
    func testFetchData() {
        let data = viewModel.fetchData()

        XCTAssertEqual(data.id, mockItemListModel.id)
        XCTAssertEqual(data.title, mockItemListModel.title)
        XCTAssertEqual(data.details.tags, mockItemListModel.details.tags)
    }
}
