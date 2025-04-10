//
//  MainViewController.swift
//  ANF Code Test
//
//  Created by Louis on 4/9/25.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    var stackView: UITableView!
    var viewModel: MainViewModel!
    var localDataModels: [LocalDataModel]?
    private var isUsingLocalJson = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let spinnerVC = SpinnerViewController()

        viewModel = MainViewModel()
        if isUsingLocalJson {
            localDataModels = viewModel.exploreData
        } else {
            viewModel.fetchDataModel { data in
                DispatchQueue.main.async {
                    spinnerVC.willMove(toParent: nil)
                    spinnerVC.view.removeFromSuperview()
                    spinnerVC.removeFromParent()
                    self.localDataModels = data
                    self.stackView.reloadData()
                }
            }
        }
       
        stackView = UITableView(frame: self.view.bounds, style: .plain)
        stackView.separatorStyle = .none
        stackView.backgroundColor = .systemBackground
        stackView.rowHeight = UITableView.automaticDimension
        
        stackView.delegate = self
        stackView.dataSource = self
        
        stackView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        
        self.view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
        
        if !isUsingLocalJson {
            // add the spinner view controller
            addChild(spinnerVC)
            spinnerVC.view.frame = view.frame
            view.addSubview(spinnerVC.view)
            spinnerVC.didMove(toParent: self)
        }
       
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localDataModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        // set delegate
        cell.delegate = self
        cell.selectionStyle = .none
        if let localDataModel = localDataModels?[indexPath.row] {
            cell.configure(dataModel: localDataModel)
        }

        cell.indexPathRow = indexPath.row
  
        return cell
    }
    
}

extension MainViewController: CellImageDelegate {
    func didLoadImage(for cell: CustomCell, image: UIImage) {
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
