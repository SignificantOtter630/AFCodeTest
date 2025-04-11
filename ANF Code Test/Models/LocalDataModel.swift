//
//  LocalDataModel.swift
//  ANF Code Test
//
//  Created by Louis on 4/11/25.
//

import Foundation
import UIKit

class LocalDataModel {
    let title: String?
    let backgroundImageString: String?
    var backgroundImage: UIImage?
    let content: [Content]?
    let promoMessage: String?
    let topDescription: String?
    let bottomDescription: String?
    
    init(from dataModel: DataModel) {
        self.title = dataModel.title
        self.content = dataModel.content
        self.promoMessage = dataModel.promoMessage
        self.topDescription = dataModel.topDescription
        self.bottomDescription = dataModel.bottomDescription
        self.backgroundImageString = dataModel.backgroundImage
        
        if let imageString = backgroundImageString {
            if let image = UIImage(named: imageString) {
                self.backgroundImage = image
            }
        }
    }
}
