//
//  ViewController.swift
//  GithubSearch
//
//  Created by jaewon on 2020/04/11.
//  Copyright © 2020 jaewon. All rights reserved.
//

import UIKit

class GithubSearchViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    fileprivate let viewModel = GithubSearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
    }
    
    private func configure() {
        self.tableView.delegate = self.viewModel
        self.tableView.dataSource = self.viewModel
    }
}
