//
//  ImageView+Ext.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import Kingfisher

extension UIImageView {
    func downloadImage(urlString: String) {
        self.kf.setImage(with: URL(string: urlString), placeholder: nil, options: [.transition(.fade(0.7))])
    }
}
