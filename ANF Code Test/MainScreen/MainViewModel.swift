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
    var isUsingLocalJson: Bool!
    var serviceManager: ServiceProtocol!
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
    
    init(isUsingLocalJson: Bool, serviceManager: ServiceProtocol) {
        self.serviceManager = serviceManager
        self.isUsingLocalJson = isUsingLocalJson
    }
    
    func startFetchingData(completion: @escaping () -> ()) {
        // either decodes the local json or fetch json from the provided url based on isUsingLocalJson Boolean
        if isUsingLocalJson {
            if let data = exploreData {
                self.localDataModels = data
                completion()
            }
        } else {
            serviceManager.fetchDataModel { data in
                self.localDataModels = data
                completion()
            }
        }
    }
}
