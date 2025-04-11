//
//  Spinners.swift
//  ANF Code Test
//
//  Created by Louis on 4/11/25.
//

import Foundation
import UIKit

// Spinner for when the app first starts and is fetching data
class SpinnerViewController: UIViewController {
    private var spinner = UIActivityIndicatorView(style: .large)
    
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

// Spinner for when the image has not been fetched yet
class ImageSpinnerView: UIView {
    private var spinner = UIActivityIndicatorView(style: .medium)
    
    func startSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: topAnchor),
            spinner.leftAnchor.constraint(equalTo: leftAnchor),
            spinner.rightAnchor.constraint(equalTo: rightAnchor),
            spinner.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
    }
}
