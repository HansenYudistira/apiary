import XCTest
@testable import apiary
import Foundation

final class MockResponseValidator: ResponseValidatorProtocol {
    var shouldThrowError = false
    var thrownError: Error = NetworkError.unknownError

    func validate(_ response: URLResponse) throws {
        if shouldThrowError {
            throw thrownError
        }
    }
}

final class URLProtocolStub: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func startLoading() {
        guard let requestHandler = URLProtocolStub.requestHandler else {
            fatalError("Request handler not set!")
        }
        do {
            let (response, data) = try requestHandler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

@available(iOS, deprecated: 13.0)
final class NetworkManagerTests: XCTestCase {
    func testGetDataSuccess() {
        let mockSession = MockURLSession()
        let jsonString = #"""
        {
            "meals": [
                { "idMeal": "1", "strMeal": "Test Meal" }
            ]
        }
        """#

        mockSession.mockData = jsonString.data(using: .utf8)
        XCTAssertNotNil(mockSession.mockData, "Mock data conversion failed")
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://mockurl.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let mockResponseValidator = MockResponseValidator()
        let networkManager = NetworkManager(urlSession: mockSession, responseValidator: mockResponseValidator)

        let expectation = self.expectation(description: "Completion handler called")

        networkManager.get(url: "https://mockurl.com") { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data, "Expected valid data but got nil")
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let dict = json as? [String: Any], let meals = dict["meals"] as? [[String: Any]] else {
                        XCTFail("Expected JSON response with meals array")
                        return
                    }
                    XCTAssertEqual(meals.first?["strMeal"] as? String, "Test Meal", "Unexpected meal name")
                } catch {
                    XCTFail("JSON parsing error: \(error)")
                }
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testGetDataFailure() {
        let mockSession = MockURLSession()
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "mockUrl")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let mockValidator = MockResponseValidator()
        mockValidator.shouldThrowError = true
        mockValidator.thrownError = NetworkError.invalidResponse

        let networkManager = NetworkManager(urlSession: mockSession, responseValidator: mockValidator)

        let expectation = self.expectation(description: "Completion handler called")

        networkManager.get(url: "mockUrl") { result in
            switch result {
            case .success:
                XCTFail("Expected an error to be thrown, but the call succeeded")
            case .failure(let error as NetworkError):
                XCTAssertEqual(error, NetworkError.invalidResponse, "Expected invalidResponse error")
            case .failure(let error):
                XCTFail("Unexpected error type: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
}

@available(iOS, deprecated: 13.0)
final class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        let task = MockURLSessionDataTask {
            if let error = self.mockError {
                completionHandler(nil, nil, error)
            } else {
                completionHandler(self.mockData, self.mockResponse, nil)
            }
        }
        return task
    }
}

final class MockURLSessionDataTask: URLSessionDataTask, @unchecked Sendable {
    private let closure: () -> Void

    @available(iOS, deprecated: 13.0)
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}
