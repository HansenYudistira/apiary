import Combine

internal class ItemListPageViewModel: ItemListPageViewModelProtocol {
    internal let itemCategoryModel: ItemCategoryModel
    @Published var errorMessage: String?
    private var tagsOnFilter: [String] = []
    private let coordinator: Coordinator

    init(contract: ItemListPageViewModelContract) {
        self.itemCategoryModel = contract.parameters
        self.coordinator = contract.coordinator
    }

    internal func fetchData() -> [ViewItemListModel] {
        let viewItemListModel = itemCategoryModel.items
            .map { $0.toViewItemListModel()}
            .sorted { $0.id < $1.id }
        return viewItemListModel
    }

    internal func fetchTitle() -> String {
        let title = itemCategoryModel.name.capitalized
        return title
    }

    internal func fetchTags() -> [String] {
        let tags = itemCategoryModel.items
            .map { $0.details.tags }
            .flatMap { $0 }
        return Array(Set(tags)).sorted()
    }

    internal func fetchFilteredData(with tag: String, status: Bool) -> [ViewItemListModel] {
        if status {
            tagsOnFilter.append(tag)
        } else {
            tagsOnFilter.removeAll { $0 == tag }
        }
        let filtered = itemCategoryModel.items
            .filter {
                let itemTags = $0.details.tags
                return tagsOnFilter.isEmpty || itemTags.contains(where: { tagsOnFilter.contains($0) })
            }
            .map { $0.toViewItemListModel() }
            .sorted { $0.id < $1.id }
        return filtered
    }
    
    internal func searchItems(with query: String) -> [ViewItemListModel] {
        let filteredItems = itemCategoryModel.items
            .filter { $0.title.lowercased().contains(query.lowercased()) }
            .map { $0.toViewItemListModel() }
            .sorted { $0.id < $1.id }
        return filteredItems
    }

    internal func clearTagsFilter() {
        tagsOnFilter.removeAll()
    }
    
    internal func navigateToDetail(for item: ViewItemListModel) {
        let parameters = itemCategoryModel.items.first(where: { $0.id == item.id })
        guard
            let parameters
        else {
            self.errorMessage = "No item found for \(item.title)"
            return
        }
        self.coordinator.navigate(to: .detailPage(parameters))
    }
}
