internal struct ItemDetailModel: Decodable {
    let author: String
    let published_date: String
    let tags: [String]
}
