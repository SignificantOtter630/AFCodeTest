//
//  DataModel.swift
//  ANF Code Test
//
//  Created by Louis on 4/9/25.
//

import Foundation
import UIKit

struct DataModel: Codable {
    let title: String?
    let backgroundImage: String?
    let content: [Content]?
    let promoMessage: String?
    let topDescription: String?
    let bottomDescription: String?
}

// MARK: - Content model
struct Content: Codable {
    let target: String?
    let title: String?
    let elementType: String?
}

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
