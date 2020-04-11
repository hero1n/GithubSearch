//
//  GithubSearchCell.swift
//  GithubSearch
//
//  Created by jaewon on 2020/04/11.
//  Copyright © 2020 jaewon. All rights reserved.
//

import UIKit

protocol GithubSearchCell {
    var item: GithubSearchViewModelItem? { get }
    var viewModel: GithubSearchViewModel? { get }
}

extension GithubSearchCell {
    var item: GithubSearchViewModelItem? {
        return nil
    }
    
    var viewModel: GithubSearchViewModel? {
        return nil
    }
}

class GithubSearchUserCell: UITableViewCell, GithubSearchCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var repoCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
