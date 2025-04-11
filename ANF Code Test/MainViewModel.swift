//
//  MainViewModel.swift
//  ANF Code Test
//
//  Created by Louis on 4/9/25.
//

import Foundation
import UIKit

class MainViewModel {
    var localDataModels: [LocalDataModel]!
    var isUsingLocalJson = false
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
    
    init(completion: @escaping () -> ()) {
        // either decodes the local json or fetch json from the provided url based on isUsingLocalJson Boolean
        if isUsingLocalJson {
            if let data = exploreData {
                self.localDataModels = data
                completion()
            }
        } else {
            fetchDataModel { data in
                self.localDataModels = data
                completion()
            }
        }
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
                    completion(localDataModels)
                } catch {
                    print("Decoding error: \(error)")
                }
            }

            task.resume()
    }
}
