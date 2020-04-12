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
    
    var user: GithubSearchModel.User? {
        didSet {
            guard let user = self.user else { return }
            
            self.userNameLabel.text = user.userName
            self.repoCountLabel.text = "Number of repos: \(user.repoCount ?? 0)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
