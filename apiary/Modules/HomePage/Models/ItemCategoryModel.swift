internal struct ItemCategoryModel: Decodable {
    let id: Int
    let name: String
    let items: [ItemListModel]
}

extension ItemCategoryModel {
    func toViewCategoryListModel() -> ViewCategoryListModel {
        return ViewCategoryListModel(
            id: id,
            name: name,
            item_count: items.count
        )
    }
}
