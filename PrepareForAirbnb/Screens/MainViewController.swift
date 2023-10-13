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
    private var tapGesture = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
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
        tapGesture.addTarget(self, action: #selector(handleTap))
        tapGesture.delegate = self
//        tapGesture.cancelsTouchesInView = false
        tapGesture.isEnabled = false
        mainTblView.addGestureRecognizer(tapGesture)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        mainTblView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func refresh() {
        self.prepareData()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true) // Dismiss the keyboard
            tapGesture.isEnabled = false
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let destVC = AppetizerDetailViewController()
        self.navigationController?.pushViewController(destVC, animated: true)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.tapGesture.isEnabled = true
        return true
    }
    
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
        self.tapGesture.isEnabled = false
        searchBar.resignFirstResponder()
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    // This delegate method allows the gesture recognizer to work alongside table view interactions.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

