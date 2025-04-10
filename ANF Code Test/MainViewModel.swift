//
//  MainViewModel.swift
//  ANF Code Test
//
//  Created by Louis on 4/9/25.
//

import Foundation

class MainViewModel {
    var exploreData: [DataModel]? {
        if let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json"),
           let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
            do {
                let dataModels = try JSONDecoder().decode([DataModel].self, from: fileContent)
                return dataModels
            } catch {
                print("Error decoding JSON: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func fetchData(completion: @escaping ([DataModel]) -> ()) {
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
                    let dataModel = try JSONDecoder().decode([DataModel].self, from: data)
                    print(dataModel)
                    completion(dataModel)
                } catch {
                    print("Decoding error: \(error)")
                }
            }

            task.resume()
    }
}
