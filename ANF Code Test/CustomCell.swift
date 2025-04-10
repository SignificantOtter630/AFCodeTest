//
//  CustomCell.swift
//  ANF Code Test
//
//  Created by Louis on 4/9/25.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    var backgroundImageView = UIImageView()
    var topDescriptionLabel = UILabel()
    var titleLabel = UILabel()
    var promoMessageLabel = UILabel()
    var bottomDescriptionLabel = UILabel()
    var contentTable = ContentTableView()
    var contents: [Content]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentTable = ContentTableView(frame: self.frame, style: .plain)
        contentTable.isScrollEnabled = false
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        topDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        promoMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentTable.translatesAutoresizingMaskIntoConstraints = false

        
        contentView.layoutMargins = .zero
        contentView.preservesSuperviewLayoutMargins = false
        
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(topDescriptionLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(promoMessageLabel)
        contentView.addSubview(bottomDescriptionLabel)
        contentView.addSubview(contentTable)
        
        topDescriptionLabel.textAlignment = .center
        titleLabel.textAlignment = .center
        promoMessageLabel.textAlignment = .center
        
        bottomDescriptionLabel.textAlignment = .center
        bottomDescriptionLabel.isUserInteractionEnabled = true
        
        topDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        promoMessageLabel.font = UIFont.systemFont(ofSize: 11)
        bottomDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
        
        //TODO: Testing
//        contentTable.backgroundColor = .cyan
        
        contentTable.separatorStyle = .none
        
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implmeneted")
    }
    
    func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            backgroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            backgroundImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            topDescriptionLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 25),
            topDescriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            topDescriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topDescriptionLabel.bottomAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            promoMessageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            promoMessageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            promoMessageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            bottomDescriptionLabel.topAnchor.constraint(equalTo: promoMessageLabel.bottomAnchor, constant: 20),
            bottomDescriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            bottomDescriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            contentTable.topAnchor.constraint(equalTo: bottomDescriptionLabel.bottomAnchor, constant: 20),
            contentTable.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            contentTable.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            contentTable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
        
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    func configureBackgroundImage(with image: UIImage) {
        // Set the image for the UIImageView
        backgroundImageView.contentMode = .scaleAspectFit
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.backgroundImageView.image = image

        backgroundImageView.widthAnchor.constraint(equalToConstant: contentView.frame.width).isActive = true
        
        backgroundImageView.layoutIfNeeded()
        backgroundImageView.image = image
        if let size = backgroundImageView.image?.size {
            backgroundImageView.heightAnchor.constraint(equalToConstant: (size.height / size.width) * backgroundImageView.frame.width).isActive = true
        }
        
        // After setting the image, force the layout to update
        backgroundImageView.setNeedsLayout()
        backgroundImageView.layoutIfNeeded()
    }
    
    func setAttributedText(with string: String) {
        guard let data = string.data(using: .utf8) else { return }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        if let attributedText = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) {
            
            // Apply custom styles to the full string
            let fullRange = NSRange(location: 0, length: attributedText.length)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            attributedText.addAttributes([
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.label,
                .font: UIFont.systemFont(ofSize: 14) 
            ], range: fullRange)
            
            // Remove underline and blue color from links
            attributedText.enumerateAttribute(.link, in: fullRange, options: []) { value, range, _ in
                if value != nil {
                    attributedText.removeAttribute(.underlineStyle, range: range)
                    attributedText.addAttribute(.foregroundColor, value: UIColor.label, range: range)
                }
            }
            
            bottomDescriptionLabel.attributedText = attributedText
        }
    }
    
    func setupContentTable(contents: [Content]) {
        self.contents = contents
        contentTable.dataSource = self
        contentTable.delegate = self
        contentTable.register(ButtonCell.self, forCellReuseIdentifier: "ButtonCell")
        backgroundImageView.setNeedsLayout()
        backgroundImageView.layoutIfNeeded()
    }
}

extension CustomCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
        guard let content = contents?[indexPath.row] else {
            return cell
        }
        
        // Configure the button
        cell.button.setTitle(content.title, for: .normal)
        cell.button.tag = indexPath.row  // Store the index in the button tag
        
        // Add target to the button
//        cell.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
}
