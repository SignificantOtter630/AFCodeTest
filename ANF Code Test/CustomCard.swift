//
//  CustomCell.swift
//  ANF Code Test
//
//  Created by Louis on 4/9/25.
//

import Foundation
import UIKit

protocol CellImageDelegate: AnyObject {
    func didLoadImage(for cell: CustomCard, image: UIImage)
}

class CustomCard: UIStackView {
    var backgroundImageView = UIImageView()
    var topDescriptionLabel = UILabel()
    var titleLabel = UILabel()
    var promoMessageLabel = UILabel()
    var bottomDescriptionTextView = UITextView()
    var bottomContentStack = UIStackView()
    var indexPathRow: Int?
    weak var delegate: CellImageDelegate?
    var viewModel: CustomCellViewModel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        topDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        promoMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        bottomContentStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(backgroundImageView)
        addSubview(topDescriptionLabel)
        addSubview(titleLabel)
        addSubview(promoMessageLabel)
        addSubview(bottomDescriptionTextView)
        addSubview(bottomContentStack)
        
        topDescriptionLabel.textAlignment = .center
        titleLabel.textAlignment = .center
        promoMessageLabel.textAlignment = .center
        
        bottomDescriptionTextView.textAlignment = .center
        bottomDescriptionTextView.isUserInteractionEnabled = true
        
        topDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        promoMessageLabel.font = UIFont.systemFont(ofSize: 11)
        bottomDescriptionTextView.font = UIFont.systemFont(ofSize: 13)
                
        bottomContentStack.axis = .vertical
        bottomContentStack.spacing = 8
        bottomContentStack.alignment = .fill
        bottomContentStack.distribution = .fillEqually
        
        
        
        setupLayoutConstraints()
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(dataModel: LocalDataModel) {
        viewModel?.dataModel = dataModel
        
        if let image = dataModel.backgroundImage {
            configureBackgroundImage(with: image)
        }
        self.titleLabel.text = dataModel.title
        self.promoMessageLabel.text = dataModel.promoMessage
        self.topDescriptionLabel.text = dataModel.topDescription
        if let contents = dataModel.content {
            setupContentStack(with: contents)
        }
        
        setupLayoutConstraints()

        if let bottomDescripton = dataModel.bottomDescription {
            setAttributedText(with: bottomDescripton)
        }
        self.layoutIfNeeded()
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            topDescriptionLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 25),
            topDescriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            topDescriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topDescriptionLabel.bottomAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            promoMessageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            promoMessageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            promoMessageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            bottomDescriptionTextView.topAnchor.constraint(equalTo: promoMessageLabel.bottomAnchor, constant: 20),
            bottomDescriptionTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            bottomDescriptionTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            bottomContentStack.topAnchor.constraint(equalTo: bottomDescriptionTextView.bottomAnchor, constant: 20),
            bottomContentStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            bottomContentStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            bottomContentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }
    
    func configureBackgroundImage(with image: UIImage) {
        // Set the image for the UIImageView
        self.backgroundImageView.image = image
        backgroundImageView.contentMode = .scaleAspectFit
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.layoutIfNeeded() //this is needed for some reason, otherwise backgroundImageView.frame.width will be zero

        backgroundImageView.backgroundColor = .red
        
        if let size = backgroundImageView.image?.size {
            backgroundImageView.heightAnchor.constraint(equalToConstant: (size.height / size.width) * backgroundImageView.frame.width).isActive = true
        }
        
        // After setting the image, force the layout to update
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setAttributedText(with string: String) {
        
        // Configure text view properties
        bottomDescriptionTextView.isEditable = false
        bottomDescriptionTextView.isScrollEnabled = false
        bottomDescriptionTextView.backgroundColor = .clear
        bottomDescriptionTextView.textAlignment = .center // Set alignment here
        
        // Set default values if none provided
        let font = UIFont.systemFont(ofSize: 13)
        let linkTextColor = UIColor.label
        
        // Convert HTML to attributed string
        if let data = string.data(using: .utf8) {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            
            do {
                let attributedString = try NSMutableAttributedString(
                    data: data,
                    options: options,
                    documentAttributes: nil
                )
                
                // Create paragraph style for alignment
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                // Apply custom styling to links
                bottomDescriptionTextView.linkTextAttributes = [
                    .foregroundColor: linkTextColor,
                    .underlineStyle: 0, // No underline
                    .font: font
                ]
                
                // Apply base font and alignment to entire string
                let fullRange = NSRange(location: 0, length: attributedString.length)
                attributedString.addAttributes([
                    .font: font,
                    .paragraphStyle: paragraphStyle
                ], range: fullRange)
                
                bottomDescriptionTextView.attributedText = attributedString
                
            } catch {
                // Fallback to plain text if HTML parsing fails
                bottomDescriptionTextView.text = string
                bottomDescriptionTextView.font = font
                bottomDescriptionTextView.textAlignment = .center
                print("Error converting HTML: \(error.localizedDescription)")
            }
        }
    }
    
    func setupContentStack(with contents: [Content]) {
        for content in contents {
            let button = UIButton(type: .system)
            button.setTitle(content.title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.systemGray.cgColor
            bottomContentStack.addArrangedSubview(button)
        }
        
        bottomContentStack.layoutIfNeeded()
        
    }
}

class CustomCellViewModel {
    var dataModel: LocalDataModel?
}

