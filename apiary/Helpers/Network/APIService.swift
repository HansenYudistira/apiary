// Used for saving Base URL for API Purpose
struct APIService {
    let baseURL: String = "https://private-0fbe4a-hansenyudistira.apiary-mock.com"
    var method: HTTPMethod = .GET
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}
