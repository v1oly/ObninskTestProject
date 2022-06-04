import Foundation
import UIKit

struct NewsModel {
    var newsArray: [NewsAPIResponse] = []
}
struct ImageModel {
    var imageArray: [Int:UIImage] = [:]
}

struct NewsAPIResponse: Codable {
    let id: String
    let title: String
    let text: String
    let date: Int
    let image: [SmallImage?]
}

struct SmallImage: Codable {
    var small: String?
}

//    let type: String?
//    let plus: String
//    let minus: Int
//    let tag: String
//    let tagID: String
//    let author: String
//    let link: String
//    let review_count: Int

//    var original: String?
