import Foundation

enum NetworkError: Error, Equatable {
    case noData
    case noResponse
    case invalidResponse
    case invalidURL
    case invalidParameters
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case unknownError

    internal var errorDescription: String? {
        switch self {
        case .noData:
            return "No data"
        case .noResponse:
            return "No response"
        case .invalidResponse:
            return "Invalid response"
        case .invalidURL:
            return "Invalid URL"
        case .invalidParameters:
            return "Invalid request parameters"
        case .clientError(let statusCode):
            return "Client error has occured. Status code: \(statusCode)"
        case .serverError(statusCode: let statusCode):
            return "Server error has occured. Status code: \(statusCode)"
        case .unknownError:
            return "An Unknown error occured."
        }
    }
}
