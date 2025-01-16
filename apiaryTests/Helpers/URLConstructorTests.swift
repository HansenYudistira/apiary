import XCTest
@testable import apiary

final class URLConstructorTests: XCTestCase {
    func testConstructKeywordstoURL() throws {
        let urlConstructor = URLConstructor()
        let url = urlConstructor.constructURL()
        XCTAssertEqual(
            url,
            "https://private-0fbe4a-hansenyudistira.apiary-mock.com/questions"
        )
    }
}
