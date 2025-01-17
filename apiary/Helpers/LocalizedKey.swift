import UIKit

// Return NSLocalizedString to prevent hard code string in ViewControllers
enum LocalizedKey: String {
    case search
    case ok
    case cancel
    case error
    case loading
    case title
    case itemCount

    var localized: String {
        let key: String = String(describing: self)
        return NSLocalizedString(key, comment: self.comment)
    }

    private var comment: String {
        switch self {
        case .search:
            return "Search bar placeholder"
        case .ok:
            return "Okay"
        case .cancel:
            return "Cancel"
        case .error:
            return "Error"
        case .loading:
            return "Loading..."
        case .title:
            return "Title"
        case .itemCount:
            return "Items count"
        }
    }
}
