import XCTest
@testable import apiary

final class ResponseValidatorTests: XCTestCase {
    private var validator: ResponseValidatorProtocol!

    override func setUp() {
        super.setUp()
        validator = ResponseValidator()
    }

    override func tearDown() {
        validator = nil
        super.tearDown()
    }

    func testValidate_WithSuccessStatusCode_ShouldNotThrow() throws {
        let response = HTTPURLResponse(
            url: URL(string: "https://testCaseURL.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        XCTAssertNoThrow(try validator.validate(response))
    }

    func testValidate_With400StatusCode_ShouldThrowInvalidParameters() throws {
        let response = HTTPURLResponse(
            url: URL(string: "https://testCaseURL.com")!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )!

        XCTAssertThrowsError(try validator.validate(response)) { error in
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidParameters)
        }
    }

    func testValidate_With404StatusCode_ShouldThrowInvalidURL() throws {
        let response = HTTPURLResponse(
            url: URL(string: "https://testCaseURL.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!

        XCTAssertThrowsError(try validator.validate(response)) { error in
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidURL)
        }
    }

    func testValidate_With401StatusCode_ShouldThrowClientError() throws {
        let response = HTTPURLResponse(
            url: URL(string: "https://testCaseURL.com")!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil
        )!

        XCTAssertThrowsError(try validator.validate(response)) { error in
            if case let NetworkError.clientError(statusCode) = error {
                XCTAssertEqual(statusCode, 401)
            } else {
                XCTFail("Expected clientError but got \(error)")
            }
        }
    }

    func testValidate_With500StatusCode_ShouldThrowServerError() throws {
        let response = HTTPURLResponse(
            url: URL(string: "https://testCaseURL.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!

        XCTAssertThrowsError(try validator.validate(response)) { error in
            if case let NetworkError.serverError(statusCode) = error {
                XCTAssertEqual(statusCode, 500)
            } else {
                XCTFail("Expected serverError but got \(error)")
            }
        }
    }

    func testValidate_WithUnknownStatusCode_ShouldThrowUnknownError() throws {
        let response = HTTPURLResponse(
            url: URL(string: "https://testCaseURL.com")!,
            statusCode: 600,
            httpVersion: nil,
            headerFields: nil
        )!

        XCTAssertThrowsError(try validator.validate(response)) { error in
            XCTAssertEqual(error as? NetworkError, NetworkError.unknownError)
        }
    }

}
