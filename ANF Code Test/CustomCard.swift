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
    var bottomDescriptionLabel = UILabel()
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
        bottomDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomContentStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(backgroundImageView)
        addSubview(topDescriptionLabel)
        addSubview(titleLabel)
        addSubview(promoMessageLabel)
        addSubview(bottomDescriptionLabel)
        addSubview(bottomContentStack)
        
        topDescriptionLabel.textAlignment = .center
        titleLabel.textAlignment = .center
        promoMessageLabel.textAlignment = .center
        
        bottomDescriptionLabel.textAlignment = .center
        bottomDescriptionLabel.isUserInteractionEnabled = true
        
        topDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        promoMessageLabel.font = UIFont.systemFont(ofSize: 11)
        bottomDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
                
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
        
        configureBackgroundImage(with: dataModel.backgroundImage)
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
            bottomDescriptionLabel.topAnchor.constraint(equalTo: promoMessageLabel.bottomAnchor, constant: 20),
            bottomDescriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            bottomDescriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            bottomContentStack.topAnchor.constraint(equalTo: bottomDescriptionLabel.bottomAnchor, constant: 20),
            bottomContentStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            bottomContentStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            bottomContentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            bottomContentStack.heightAnchor.constraint(equalToConstant: 100)
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
    
    func setupContentStack(with contents: [Content]) {
       
//        for i in 1...5 {
//            let button = UIButton(type: .system)
//            button.setTitle("Button \(i)", for: .normal)
//            button.backgroundColor = .systemBlue
//            button.setTitleColor(.white, for: .normal)
//            button.layer.cornerRadius = 8
//            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
////            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//            bottomContentStack.addArrangedSubview(button)
//        }
        
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

class TestStackView {
    
}
