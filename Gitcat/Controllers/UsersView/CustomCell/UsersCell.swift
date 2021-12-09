//
//  UsersCell.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit

class UsersCell: UITableViewCell {
    static let profileImageSize: CGSize = CGSize(width: 50, height: 50)
    @IBOutlet var userName: UILabel!
    @IBOutlet var userAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
