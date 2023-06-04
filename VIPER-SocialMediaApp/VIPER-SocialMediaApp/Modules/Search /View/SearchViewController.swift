//
//  SearchViewController.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 27.05.2023.
//

import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    func displayUsers(_ users: [User])
    func displayError(_ message: String)
}

protocol SearchViewProtocol: class {
    func showLoading(_ isLoading: Bool)
    func getUsers(_ user: [User])
}

class SearchViewController: UIViewController, SearchViewProtocol {
    private var presenter: SearchPresenterProtocol!
    var tableView = UITableView()
    private var users: [User] = []
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePresenter()
        setupTableView()
        presenter.viewDidLoad()
        setupSearchBar()
    }
    
    private func configurePresenter() {
        let interactor = SearchInteractor(service: NetworkManager())
        let router = SearchRouter(viewController: self)
        presenter = SearchPresenter(view: self, interactor: interactor, router: router)
        interactor.delegate = presenter as? SearchInteractorDelegate
    }
    
    func showLoading(_ isLoading: Bool) { }
    
    func getUsers(_ user: [User]) {
        users = user
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell")
        view.addSubview(tableView)
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search User"
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = .minimal
        navigationItem.titleView = searchBar
     }
    
    private func showError(message: String) {    }

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        var post = users[indexPath.item]
        cell.usernameLabel.text = post.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectUser(at: indexPath.row)
    }
}

class UserTableViewCell: UITableViewCell {
     var usernameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        stylee()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with user: User) {
        usernameLabel.text = user.username
    }
}

extension UserTableViewCell {
    func stylee() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        contentView.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            usernameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredUsers = users.filter { user in
            return user.username.lowercased().contains(searchText.lowercased())
               }
               
               // Tabloyu güncelle
               tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
