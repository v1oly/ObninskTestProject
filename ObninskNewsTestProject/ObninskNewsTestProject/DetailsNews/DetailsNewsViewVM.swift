import Foundation
import UIKit

class DetailsNewsViewVM {

    let urlSession = URLSession.shared
    
    func parseFromNewsId(id: String, completion: @escaping (DetailsNewsAPIResponse, UIImage?) -> ()) {
        let parseLink = "http://obninsk.name/api.php?get=post&ID=\(id)"
        parseFromUrl(urlString: parseLink, codableStruct: [DetailsNewsAPIResponse].self) { [weak self] decodedData in
            self?.loadImageFromUrl(url: decodedData[0].image[0]?.original ?? "") { image in
                DispatchQueue.main.async {
                completion(decodedData[0], image)
                }
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
