//
//  MainViewModel.swift
//  ANF Code Test
//
//  Created by Louis on 4/9/25.
//

import Foundation
import UIKit

class MainViewModel {
    var exploreData: [LocalDataModel]? {
        if let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json"),
           let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
            do {
                let dataModels = try JSONDecoder().decode([DataModel].self, from: fileContent)
                let localDataModels = dataModels.map {
                    LocalDataModel(from: $0)
                }
                return localDataModels
            } catch {
                print("Error decoding JSON: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func fetchDataModel(completion: @escaping ([LocalDataModel]) -> ()) {
        guard let url = URL(string: "https://www.abercrombie.com/anf/nativeapp/qa/codetest/codeTest_exploreData.json") else {
                print("Invalid URL")
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching promos: \(error)")
                    return
                }

                guard let data = data else {
                    print("No data received")
                    return
                }

                do {
                    let dataModels = try JSONDecoder().decode([DataModel].self, from: data)
                    let localDataModels = dataModels.map {
                        LocalDataModel(from: $0)
                    }
                    sleep(2)
                    completion(localDataModels)
                } catch {
                    print("Decoding error: \(error)")
                }
            }

            task.resume()
    }
    
    func fetchImage(from urlString: String, completion: @escaping (UIImage) -> Void) {
        // a bit of a hack to make the image urls use https
        let httpsString = urlString.replacingOccurrences(of: "http://", with: "https://")
        guard let url = URL(string: httpsString) else {
            print("Invalid URL")
            return
        }
        
        // Create a data task to fetch the image data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Convert the data into a UIImage
            if let image = UIImage(data: data) {
                sleep(2)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                print("Failed to create image from data")
            }
        }.resume()
    }
}
