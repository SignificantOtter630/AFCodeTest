//
//  DataModel.swift
//  ANF Code Test
//
//  Created by Louis on 4/9/25.
//

import Foundation

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
