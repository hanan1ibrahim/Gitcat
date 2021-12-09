//
//  ReposCell.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit
import Kingfisher

class ReposCell: UITableViewCell {
    @IBOutlet weak var userRepoName: UILabel!
    @IBOutlet weak var userRepoDescription: UILabel!
    @IBOutlet weak var userRepoStars: UILabel!
    @IBOutlet weak var userRepoLangauge: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
