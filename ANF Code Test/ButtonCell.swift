//
//  ContentTable.swift
//  ANF Code Test
//
//  Created by Louis on 4/9/25.
//

import Foundation
import UIKit

class ButtonCell: UITableViewCell {
    var button: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupButton()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupButton()
        }
        
        func setupButton() {
            // Initialize the button and add it to the content view
            button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.systemGray.cgColor
            contentView.addSubview(button)
            
            // Set button constraints
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
                button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
                button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
                button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3)
            ])
        }
}

class ContentTableView: UITableView {
    
    override open var contentSize: CGSize {
        didSet { // the contentSize gets changed each time a cell is added
            // --> the intrinsicContentSize gets also changed leading to smooth size update
            if oldValue != contentSize {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height)
    }
}

class ContentButton: UIButton {
    
}
