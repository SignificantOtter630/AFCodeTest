//
//  CustomCardViewModel.swift
//  ANF Code Test
//
//  Created by Louis on 4/10/25.
//

import Foundation
import UIKit

class CustomCardViewModel {
    var dataModel: LocalDataModel!
    var serviceManager: ServiceProtocol!
    
    init(dataModel: LocalDataModel, serviceManager: ServiceProtocol) {
        self.dataModel = dataModel
        self.serviceManager = serviceManager
    }
    
    func fetchImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageString = dataModel.backgroundImageString else {
            return
        }
        serviceManager.fetchImage(imageString: imageString) { image in
            self.dataModel.backgroundImage = image
            completion(image)
        }
    }
}
