//
//  ProfileTableViewCell.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func cellData (with model: ProfileTableData) {
        textLabel?.text = model.cellHeader
        imageView?.image = UIImage(named: model.image)
        imageView?.layer.cornerRadius = 10
        imageView?.clipsToBounds = true
    }


}
