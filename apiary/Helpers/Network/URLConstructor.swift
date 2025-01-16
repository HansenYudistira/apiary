import Foundation

protocol URLConstructorProtocol {
    func constructURL() -> String
}

struct URLConstructor: URLConstructorProtocol {
    func constructURL() -> String {
        let apiService: APIService = .init()
        var components = URLComponents(string: apiService.baseURL)
        components?.path = "/questions"
        return components?.url?.absoluteString ?? ""
    }
}
