import Foundation

struct DetailsNewsAPIResponse: Codable {
    let type: String?
    let id: String
    let plus: String
    let minus: Int
    let tag: String
    let tagID: String
    let title: String
    let author: String
    let link: String
    let text: String
    let date: Int
    let review_count: Int
    let image: [OriginalImage?]
}

struct OriginalImage: Codable {
    var original: String?
}
