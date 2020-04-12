//
//  GithubSearchViewModel.swift
//  GithubSearch
//
//  Created by jaewon on 2020/04/11.
//  Copyright © 2020 jaewon. All rights reserved.
//

import UIKit

enum GithubSearchViewModelItemType {
    case user
}

protocol GithubSearchViewModelItem {
    var type: GithubSearchViewModelItemType { get }
    var rowCount: Int { get }
}

extension GithubSearchViewModelItem {
    var rowCount: Int {
        return 1
    }
}

class GithubSearchViewModelUserItem: GithubSearchViewModelItem {
    var type: GithubSearchViewModelItemType {
        return .user
    }
    
    var rowCount: Int {
        return self.users.count
    }
    
    var users: [GithubSearchModel.User] = []
    
    init(_ userList: GithubSearchModel.UserList) {
        guard let userItems = userList.items else { return }
        self.users = userItems.map { GithubSearchModel.User(user: $0) }
    }
}

class GithubSearchViewModel: NSObject {
    private var items = [GithubSearchViewModelItem]()
    private var page = 1
    
    weak var viewController: GithubSearchViewController?
    
    override init() {
        super.init()
    }
    
    @objc func search(_ searchBar: UISearchBar) {
        self.items.removeAll()
        self.viewController?.tableView.reloadData()
        
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            return
        }
        
    }

extension GithubSearchViewModel: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.search(_:)), object: searchBar)
        
        perform(#selector(self.search(_:)), with: searchBar, afterDelay: 0.5)
    }
}

extension GithubSearchViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.section]
        
        switch item.type {
        case .user:
            if let cell = tableView.dequeueReusableCell(withIdentifier: GithubSearchUserCell.identifier) as? GithubSearchUserCell,
                let item = item as? GithubSearchViewModelUserItem {
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension GithubSearchViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
