//
//  MainViewController.swift
//  ANF Code Test
//
//  Created by Louis on 4/9/25.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    var viewModel: MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let spinnerVC = SpinnerViewController()
        addChild(spinnerVC)
        spinnerVC.view.frame = view.frame
        view.addSubview(spinnerVC.view)
        spinnerVC.didMove(toParent: self)
        
        viewModel.startFetchingData {
            DispatchQueue.main.async {
                self.setupScrollView()
                spinnerVC.willMove(toParent: nil)
                spinnerVC.view.removeFromSuperview()
                spinnerVC.removeFromParent()
            }
        }
    }
    
    func setupScrollView() {
        // Create the ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor(hex: "FFF7E4")
        // Pin ScrollView to the edges of the parent view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Create the content view inside the scroll view
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Pin content view to the edges of the scroll view
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Create the stack view
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        // Set constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        setupCustomCards()
    }
    
    func setupCustomCards() {
        for localDataModel in viewModel.localDataModels {
            let customCard = CustomCard()
            
            stackView.addArrangedSubview(customCard)
            let customCardVM = CustomCardViewModel(dataModel: localDataModel, serviceManager: viewModel.serviceManager)
            customCard.configure(viewModel: customCardVM)
            stackView.layoutIfNeeded()
        }
    }
}

