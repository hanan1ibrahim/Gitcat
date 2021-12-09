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
    func cellData(with model: SavedUsers) {
        self.userName.text = model.userName
        guard let avatarURL = model.userAvatar else { return }
        self.userAvatar.kf.setImage(with: URL(string: avatarURL), placeholder: nil, options: [.transition(.fade(0.7))])
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.layer.masksToBounds = false
        userAvatar.layer.cornerRadius = userAvatar.frame.height/2
        userAvatar.clipsToBounds = true
    }
}
