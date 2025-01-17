internal struct ItemListModel: Decodable {
    let id: Int
    let title: String
    let description: String
    let image_url: String
    let details: ItemDetailModel
}

// function to convert into Model for ItemListPageViewController
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
