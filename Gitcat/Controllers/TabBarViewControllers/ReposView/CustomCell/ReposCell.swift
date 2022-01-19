//
//  ReposCell.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit
import Kingfisher

class ReposCell: UITableViewCell {
    
// MARK: - IBOutlets
    @IBOutlet weak var userRepoName: UILabel!
    @IBOutlet weak var userRepoDescription: UILabel!
    @IBOutlet weak var userRepoStars: UILabel!
    @IBOutlet weak var userRepoLangauge: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
// MARK: - Function
    func cellData(with model: SavedRepositories) {
        self.userRepoName?.text = model.repoName
        self.userRepoDescription?.text = model.repoDescreipion
        self.userRepoStars?.text = String(Int.random(in: 143...4345))
        self.userRepoLangauge?.text = model.repoProgLang
    }
}
