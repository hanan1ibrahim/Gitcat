//
//  SettingsCollectionViewCell.swift
//  GitCat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit

class SettingsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var catContentView: UIView!
    @IBOutlet weak var cellTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellButton.layer.cornerRadius = 10
        catContentView.layer.cornerRadius = 40
        darkModeSwitch.isHidden = true
        cellButton.isHidden = true
    }
    @IBAction func darkModeAction(_ sender: Any) {
        if darkModeSwitch?.isOn == true {
            window?.overrideUserInterfaceStyle = .dark
        } else {
            window?.overrideUserInterfaceStyle = .light
        }
    }
    @IBAction func pressCellButton(_ sender: Any) {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
    }
    func setDarkModeCell(indexPath: IndexPath) {
        cellTitle.text = Titles.darkMode
        cellButton.isHidden = true
        darkModeSwitch.isHidden = false
    }
    func setChangeLanguageCell(indexPath: IndexPath) {
        cellTitle.text = "Change Lanuages".localized()
        cellTitle.font = UIFont(name: "Avenir-Light", size: 14.0)
        cellButton.setTitle("Change" .localized(), for: .normal)
        darkModeSwitch.isHidden = true
        cellButton.isHidden = false
        cellButton.backgroundColor = .lightGray
    }
}
