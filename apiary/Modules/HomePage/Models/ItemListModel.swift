internal struct ItemListModel: Decodable {
    let id: Int
    let title: String
    let description: String
    let image_url: String
    let details: ItemDetailModel
}

extension ItemListModel {
    func toViewItemListModel() -> ViewItemListModel {
        return ViewItemListModel(
            id: id,
            title: title,
            description: description,
            image_url: image_url
        )
    }
}
