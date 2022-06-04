import Foundation
import UIKit

class MainNewsVM {
    
    let urlSession = URLSession.shared
    var showMode = "all"
    var imageModel = ImageModel()
    var model = NewsModel() {
        didSet {
            onModelChanges()
        }
    }
    
    var newsArrey: [NewsAPIResponse] {
        return model.newsArray
    }
    
    var countOfNewsArray: Int {
        return model.newsArray.count
    }
    
    let onModelChanges: () -> ()
    
    init(onModelChanges: @escaping () -> ()) {
        self.onModelChanges = onModelChanges
    }
   
    func getDataToCell(indexPath: Int,
                       completion: @escaping (_ newsPost: NewsAPIResponse) -> ()) {
        let newsPost = model.newsArray[indexPath]
        completion(newsPost)
    }
    
    func getImageToCell(indexPath: Int, completion: @escaping (UIImage?, String) -> ()) -> String {
        let identifier = UUID().uuidString
        if imageModel.imageArray.keys.contains(indexPath) {
            DispatchQueue.main.async {
                completion(self.imageModel.imageArray[indexPath], identifier)
            }
        } else {
            loadImageFromUrl(url: model.newsArray[indexPath].image[0]?.small ?? "") { [weak self] image in
                self?.imageModel.imageArray[indexPath] = image
                DispatchQueue.main.async {
                    completion(image, identifier)
                }
            }
        }
        return identifier
    }

    
    func getParsedData(limit: Int, skip: Int, isReloaded: Bool, completion: @escaping () -> ()) {
        let link = "https://obninsk.name/api.php?get=news&limit=\(limit)&skip=\(skip)&show=\(showMode)"
        parseFromUrl(urlString: link, codableStruct: [NewsAPIResponse].self) { [weak self] decodedData in
            if isReloaded == false {
            self?.model.newsArray += decodedData
            } else {
            self?.model.newsArray = decodedData
                completion()
            }
        }
    }
    
    func parseFromUrl<T: Codable>(urlString: String,
                                  codableStruct: T.Type,
                                  completion: @escaping (T) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard data != nil else {
                print("No Data")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server Error")
                return
            }
            
            guard let mimeType = response.mimeType, mimeType == "application/json" else {
                print("Wrong mimeType")
                return
            }
            if let data = data {
                if let decodedData = self.decodeJSON(data: data, codableStruct: codableStruct) {
                    completion(decodedData)
                }
            }
        }
        task.resume()
    }
    
    private func decodeJSON<T:Decodable>(data: Data, codableStruct: T.Type) -> T? {
        let decoder = JSONDecoder()
        if let decodedText = try? decoder.decode(codableStruct.self, from: data) {
            return decodedText
        } else {
            return nil
        }
    }
    
    private func loadImageFromUrl(url: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: url) else { return }
        DispatchQueue.global(qos: .utility).async {
            if let imageData = try? Data(contentsOf: url) {
                if let image = UIImage(data: imageData) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
