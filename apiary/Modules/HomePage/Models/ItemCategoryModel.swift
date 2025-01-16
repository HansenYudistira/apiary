internal struct ItemCategoryModel: Decodable {
    let id: Int
    let name: String
    let items: [ItemListModel]
}
