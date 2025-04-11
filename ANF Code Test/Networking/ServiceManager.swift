//
//  ServiceManager.swift
//  ANF Code Test
//
//  Created by Louis on 4/11/25.
//

import Foundation
import UIKit

protocol ServiceProtocol {
    func fetchDataModel(completion: @escaping ([LocalDataModel]) -> ())
    func fetchImage(imageString: String, completion: @escaping (UIImage?) -> Void)
}

class ServiceManager: ServiceProtocol {
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
                    completion(localDataModels)
                } catch {
                    print("Decoding error: \(error)")
                }
            }

            task.resume()
    }
    
    func fetchImage(imageString: String, completion: @escaping (UIImage?) -> Void) {
        
        // a bit of a hack to change the url to use https
        let httpsSting = imageString.replacingOccurrences(of: "http://", with: "https://")
        
        guard let url = URL(string: httpsSting) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // add sleep here if testing slow image fetching
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
