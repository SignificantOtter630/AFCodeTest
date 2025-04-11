//
//  MainViewController.swift
//  ANF Code Test
//
//  Created by Louis on 4/9/25.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let stackView = UIStackView()
    var viewModel: MainViewModel!
    var localDataModels: [LocalDataModel]?
    private var isUsingLocalJson = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let spinnerVC = SpinnerViewController()

        viewModel = MainViewModel()
        if isUsingLocalJson {
            localDataModels = viewModel.exploreData
            spinnerVC.willMove(toParent: nil)
            spinnerVC.view.removeFromSuperview()
            spinnerVC.removeFromParent()
        } else {
            viewModel.fetchDataModel { data in
                DispatchQueue.main.async {
                    spinnerVC.willMove(toParent: nil)
                    spinnerVC.view.removeFromSuperview()
                    spinnerVC.removeFromParent()
                    self.localDataModels = data
                }
            }
        }
        
        setupScrollView()
        
        if !isUsingLocalJson {
            // add the spinner view controller
            addChild(spinnerVC)
            spinnerVC.view.frame = view.frame
            view.addSubview(spinnerVC.view)
            spinnerVC.didMove(toParent: self)
        }
       
        
    }
    
    func setupScrollView() {
        // Create the ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
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
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // To make sure it scrolls horizontally if necessary
        ])
        
        // Create the stack view
        stackView.axis = .vertical // or .horizontal depending on the direction
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
        guard let unrwappedlocalDataModels = localDataModels else {
            return
        }
        for localDataModel in unrwappedlocalDataModels {
            let customCard = CustomCard()
            
            stackView.addArrangedSubview(customCard)
            customCard.configure(dataModel: localDataModel)
            stackView.layoutIfNeeded()
           
        }
        
       
    }
}

extension MainViewController: CellImageDelegate {
    func didLoadImage(for cell: CustomCard, image: UIImage) {
        cell.configureBackgroundImage(with: image)
    }
}

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
}
