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
}

class GithubSearchViewModel: NSObject {
    var items = [GithubSearchViewModelItem]()
    
    override init() {
        super.init()
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
        return UITableViewCell()
    }
}

extension GithubSearchViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
