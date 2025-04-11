//
//  ContentButton.swift
//  ANF Code Test
//
//  Created by Louis on 4/11/25.
//

import Foundation
import UIKit

class ContentButton: UIButton {
    var urlString: String?
    init(content: Content) {
        super.init(frame: .zero)
        self.urlString = content.target
        self.setTitle(content.title, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.setTitleColor(.darkGray, for: .normal)
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonAction() {
        guard let urlString = urlString else {
            return
        }

        guard let url = URL(string: urlString) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:]) {_ in
            
        }
    }
}
