//
//  MainViewController.swift
//  ANF Code Test
//
//  Created by Louis on 4/9/25.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    var tableView: UITableView!
    var viewModel: MainViewModel!
    var exploreData: [DataModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainViewModel()
        exploreData = viewModel.exploreData
//        viewModel.fetchData { data in
//            DispatchQueue.main.async {
//                self.exploreData = data
//                self.tableView.reloadData()
//            }
//        }
//
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
        
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exploreData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.selectionStyle = .none
        if let backgroundImageString = exploreData?[indexPath.row].backgroundImage {
            if let backgroundImage = UIImage(named: backgroundImageString) {
                cell.backgroundImageView.image = backgroundImage
                cell.configureBackgroundImage(with: backgroundImage)
            }
        }
        
        
        cell.titleLabel.text = exploreData?[indexPath.row].title
        cell.promoMessageLabel.text = exploreData?[indexPath.row].promoMessage
        cell.topDescriptionLabel.text = exploreData?[indexPath.row].topDescription
        if let bottomDescriptionString = exploreData?[indexPath.row].bottomDescription {
            cell.setAttributedText(with: bottomDescriptionString)
        }
        
        if let contents =  exploreData?[indexPath.row].content {
            cell.setupContentTable(contents: contents)
        }
        
        cell.setupLayoutConstraints()
       
        return cell
    }
    
}
