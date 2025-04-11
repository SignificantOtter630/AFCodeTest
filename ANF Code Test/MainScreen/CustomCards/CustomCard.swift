//
//  CustomCell.swift
//  ANF Code Test
//
//  Created by Louis on 4/9/25.
//

import Foundation
import UIKit

class CustomCard: UIStackView {
    private var spinnerView = ImageSpinnerView()
    private var backgroundImageView = UIImageView()
    private var topDescriptionLabel = UILabel()
    private var titleLabel = UILabel()
    private var promoMessageLabel = UILabel()
    private var bottomDescriptionTextView = UITextView()
    private var bottomContentStack = UIStackView()
    private var indexPathRow: Int?
    private var viewModel: CustomCardViewModel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // configures all the UI for a card
    func configure(viewModel: CustomCardViewModel) {
        self.viewModel = viewModel
        backgroundImageView.backgroundColor = UIColor(hex: "FFF7E4")
        
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.startSpinner()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        topDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        promoMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        bottomContentStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(spinnerView)
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
        
        // if the current model has an image use it to configure the background image, else fetch it then configure
        if let image = viewModel.dataModel.backgroundImage {
            configureBackgroundImage(with: image)
        } else {
            viewModel.fetchImage { image in
                if let image = image {
                    self.configureBackgroundImage(with: image)
                }
            }
        }
        self.titleLabel.text = viewModel.dataModel.title
        self.promoMessageLabel.text = viewModel.dataModel.promoMessage
        self.promoMessageLabel.textColor = .darkGray
        self.topDescriptionLabel.text = viewModel.dataModel.topDescription
        if let contents = viewModel.dataModel.content {
            setupContentStack(with: contents)
        }
        

        if let bottomDescripton = viewModel.dataModel.bottomDescription {
            setAttributedText(with: bottomDescripton)
        }
        self.layoutIfNeeded()
    }
    
    // MARK: setupLayoutConstraints sets the constraints
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            spinnerView.topAnchor.constraint(equalTo: topAnchor),
            spinnerView.leftAnchor.constraint(equalTo: leftAnchor),
            spinnerView.rightAnchor.constraint(equalTo: rightAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            spinnerView.heightAnchor.constraint(equalToConstant: 400),
        ])
        
        NSLayoutConstraint.activate([
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
            bottomDescriptionTextView.topAnchor.constraint(equalTo: promoMessageLabel.bottomAnchor, constant: 15),
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
    
    // MARK: configureBackgroundImage sets up the backgroundImage. Sets the height of the image view based on the aspect ratio of the image
    func configureBackgroundImage(with image: UIImage) {
        // Set the image for the UIImageView
        self.backgroundImageView.image = image
        backgroundImageView.contentMode = .scaleAspectFit
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.layoutIfNeeded() //this is needed for some reason, otherwise backgroundImageView.frame.width will be zero
        
        if let size = backgroundImageView.image?.size {
            backgroundImageView.heightAnchor.constraint(equalToConstant: (size.height / size.width) * backgroundImageView.frame.width).isActive = true
            spinnerView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            spinnerView.stopSpinner()
        }
        
        // After setting the image, force the layout to update
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    // MARK: setAttributedText sets up the bottomDescription text
    func setAttributedText(with string: String) {
        // Configure text view properties
        bottomDescriptionTextView.isEditable = false
        bottomDescriptionTextView.isScrollEnabled = false
        bottomDescriptionTextView.backgroundColor = .clear
        bottomDescriptionTextView.textAlignment = .center
        
        let font = UIFont.systemFont(ofSize: 13)
        let textColor = UIColor.lightGray
        
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
                    .foregroundColor: textColor,
                    .underlineStyle: 0, // No underline
                    .font: font
                ]
                
                // Apply base font and alignment to entire string
                let fullRange = NSRange(location: 0, length: attributedString.length)
                attributedString.addAttributes([
                    .foregroundColor: textColor,
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
    
    // MARK: setupContentStack sets up the content buttons on the bottom
    func setupContentStack(with contents: [Content]) {
        for content in contents {
            let button = ContentButton(content: content)
            
            bottomContentStack.addArrangedSubview(button)
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        bottomContentStack.layoutIfNeeded()
    }
}
