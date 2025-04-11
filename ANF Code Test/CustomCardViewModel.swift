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
    
    init(dataModel: LocalDataModel) {
        self.dataModel = dataModel
    }
    
    func fetchImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageString = dataModel.backgroundImageString else {
            completion(nil)
            return
        }
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
                self.dataModel.backgroundImage = image
                completion(image)
            }
        }.resume()
    }
}
