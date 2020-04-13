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
        self.navigationItem.title = "Github Users"
        
        self.viewModel.viewController = self
        
        self.tableView.delegate = self.viewModel
        self.tableView.dataSource = self.viewModel
        
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        
        self.searchBar.delegate = self.viewModel
    }
}
