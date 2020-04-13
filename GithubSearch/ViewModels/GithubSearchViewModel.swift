//
//  GithubSearchViewModel.swift
//  GithubSearch
//
//  Created by jaewon on 2020/04/11.
//  Copyright © 2020 jaewon. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

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
    
    init(_ users: [GithubSearchModel.User]) {
        self.users = users
    }
}

class GithubSearchViewModel: NSObject {
    private var items = [GithubSearchViewModelItem]()
    private var page = 1
    
    weak var viewController: GithubSearchViewController?
    
    override init() {
        super.init()
    }
    
    func showSearchBarIndicator() {
        self.viewController?.searchBar.isLoading = true
    }
    
    func hideSearchBarIndicator() {
        self.viewController?.searchBar.isLoading = false
    }
    
    func hideKeyboard() {
        if self.viewController?.searchBar.isFirstResponder == true {
            self.viewController?.view.endEditing(true)
        }
    }
    
    @objc func search(_ searchBar: UISearchBar) {
        self.items.removeAll()
        self.viewController?.tableView.reloadData()
        
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            self.hideSearchBarIndicator()
            return
        }
        
        self.fetchUsers(query: query)
    }
    
    private func fetchUsers(query: String) {
        self.showSearchBarIndicator()
        SessionManager.default.startRequestsImmediately = true
        
        AlamofireUtil.shared.requestObject(
            .getUsers(query: query, page: self.page),
            onSuccess: { (response: GithubSearchModel.UserList) in
                self.fetchUserDetails(userList: response)
        }, onError: { (error) in
            self.hideSearchBarIndicator()
        })
    }
    
    private func fetchUserDetails(userList: GithubSearchModel.UserList) {
        guard let userItems = userList.items else { return }
        self.showSearchBarIndicator()
        SessionManager.default.startRequestsImmediately = false
        
        var userDetails: [GithubSearchModel.UserDetail] = []
        let userNames = userItems.compactMap { $0.userName }
        let requests = userNames.map { AlamofireUtil.shared.getDataRequest(.getSingleUser(userName: $0)) }
        let requestChain = RequestChain(requests: requests)
        
        requestChain.start { (done, error) in
            if done {
                requests.forEach {
                    $0.responseObject { (response: DataResponse<GithubSearchModel.UserDetail>) in
                        switch response.result {
                        case .success(let data):
                            userDetails.append(data)
                            
                            if userDetails.count == userItems.count {
                                self.hideSearchBarIndicator()
                                self.setData(userDetails: userDetails, with: userList)
                            }
                        case .failure:
                            return
                        }
                    }
                }
            } else {
                print(debug: error?.error ?? "")
                self.hideSearchBarIndicator()
            }
        }
    }
    
    private func setData(userDetails: [GithubSearchModel.UserDetail], with userList: GithubSearchModel.UserList) {
        guard let userItems = userList.items else { return }
        let users: [GithubSearchModel.User] = userItems.compactMap { GithubSearchModel.User(user: $0) }
        
        userDetails.forEach { (data) in
            users.first { data.id == $0.id }?.repoCount = data.repoCount
        }

        self.updateData(users: users)
    }
    
    private func updateData(users: [GithubSearchModel.User]) {
        if self.items.count == 0 {
            self.items.append(GithubSearchViewModelUserItem(users))
        } else if let userViewModelItem = self.items.first(where: { $0 is GithubSearchViewModelUserItem }) as? GithubSearchViewModelUserItem {
            userViewModelItem.users.append(contentsOf: users)
        }
        
        self.viewController?.tableView.reloadData()
    }
}

extension GithubSearchViewModel: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.search(_:)), object: searchBar)
        
        perform(#selector(self.search(_:)), with: searchBar, afterDelay: 0.5)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.hideKeyboard()
    }
}

extension GithubSearchViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.items.count > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "검색된 결과가 없습니다.\n위 검색 창에서 검색해주세요."
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 0
            
            tableView.separatorStyle = .none
            tableView.backgroundView = noDataLabel
        }
        
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
                cell.user = item.users[indexPath.row]
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension GithubSearchViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hideKeyboard()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.hideKeyboard()
    }
}
