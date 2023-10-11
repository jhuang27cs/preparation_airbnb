//
//  ViewController.swift
//  PrepareForAirbnb
//
//  Created by Jie Huang on 2023/10/10.
//

import UIKit

class MainViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let refreshControl = UIRefreshControl()
    private let mainTblView = {
        let tableView = UITableView()
        tableView.register(CollectionTableViewCell.self, 
                           forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return tableView
    }()
    
    var appetizers = [Appetizer]()
    var filteredItems = [Appetizer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        self.view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        mainTblView.delegate = self
        mainTblView.dataSource = self
        mainTblView.estimatedRowHeight = 100
        mainTblView.rowHeight = UITableView.automaticDimension
        mainTblView.frame = CGRect(x: 0, y: 50, width: self.view.bounds.width, height: self.view.bounds.height-50)
        self.view.addSubview(mainTblView)
        mainTblView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTblView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            mainTblView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainTblView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainTblView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        self.prepareData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        mainTblView.addSubview(refreshControl)
    }
    
    @objc func refresh() {
        self.prepareData()
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    private func prepareData() {
        Task {
            self.appetizers = try await NetworkManager.shared.getAppetizer()
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            self.filteredItems = self.appetizers
            self.mainTblView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell
        cell?.setupDetail(appetizer: self.filteredItems[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        return 355.33
//    }
//    
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.filteredItems = self.appetizers
        } else {
            self.filteredItems = self.appetizers.filter({ item in
                item.name.lowercased().contains(searchText.lowercased())
            })
        }
        mainTblView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

