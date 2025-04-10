//
//  CustomCell.swift
//  ANF Code Test
//
//  Created by Louis on 4/9/25.
//

import Foundation
import UIKit

protocol CellImageDelegate: AnyObject {
    func didLoadImage(for cell: CustomCell, image: UIImage)
}

class CustomCell: UITableViewCell {
    var backgroundImageView = UIImageView()
    var topDescriptionLabel = UILabel()
    var titleLabel = UILabel()
    var promoMessageLabel = UILabel()
    var bottomDescriptionLabel = UILabel()
    var bottomContentView = UIStackView()
    var indexPathRow: Int?
    weak var delegate: CellImageDelegate?
    var viewModel: CustomCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bottomContentView.backgroundColor = .cyan
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        topDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        promoMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomContentView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        contentView.layoutMargins = .zero
        contentView.preservesSuperviewLayoutMargins = false
        
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(topDescriptionLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(promoMessageLabel)
        contentView.addSubview(bottomDescriptionLabel)
        contentView.addSubview(bottomContentView)
        
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
        
        bottomContentView.axis = .vertical
        bottomContentView.spacing = 8
        bottomContentView.alignment = .fill
        bottomContentView.distribution = .fillEqually
        
        
        
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implmeneted")
    }
    
    func configure(dataModel: LocalDataModel) {
        viewModel?.dataModel = dataModel
        
        configureBackgroundImage(with: dataModel.backgroundImage)
        self.titleLabel.text = dataModel.title
        self.promoMessageLabel.text = dataModel.promoMessage
        self.topDescriptionLabel.text = dataModel.topDescription
        setupContent()
        setupLayoutConstraints()
        
        if let bottomDescripton = dataModel.bottomDescription {
            setAttributedText(with: bottomDescripton)
        }
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    private func setupLayoutConstraints() {
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
            bottomContentView.topAnchor.constraint(equalTo: bottomDescriptionLabel.bottomAnchor, constant: 20),
            bottomContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            bottomContentView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            bottomContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            bottomContentView.heightAnchor.constraint(equalToConstant: 100)
        ])
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
    
    func setupContent() {
        guard let contents = viewModel?.dataModel?.content else {
            return
        }
       
        for _ in 1...10 {
            let button = UIButton(type: .system)
            button.setTitle("Button", for: .normal)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            
            bottomContentView.addArrangedSubview(button)
        }
        
    }
}

class CustomCellViewModel {
    var dataModel: LocalDataModel?
    
    
}
