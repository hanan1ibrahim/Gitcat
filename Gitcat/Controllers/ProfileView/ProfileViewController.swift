//
//  ProfileViewController.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLogin: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userFollowers: UILabel!
    //MARK: - Props
    var profileTableData = [ProfileTableData]()
    var userRepository = [Repository]()
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    let afSession: Session = {
        let interceptor = RequestIntercptor()
        return Session(
            interceptor: interceptor)
    }()
    let conditionLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = settingsButton
        loggedInStatus(tableView: tableView, conditionLabel: conditionLabel)
    }
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    //MARK: - Functions
    func configureUI() {
        title = Titles.profileViewTitle
        tabBarItem.title = Titles.profileViewTitle
        tableView.tableFooterView = UIView()
        tableView.isHidden = true
        view.addSubview(conditionLabel)
        conditionLabel.text = Titles.noToken
    }
    func fetchData() {
        userProfileData(requestData: Router.privateUserAPIlink,
                        userName: userName, userAvatar: userAvatar, userFollowData: userFollowers,
                        userBio: userBio, userLoginName: userLogin, userLocation: userLocation, tableView: tableView)
    }
    @IBAction func didTapSettingsButton(_ sender: UIBarButtonItem) {
        
    }
    func userProfileData(requestData: Router,userName : UILabel, userAvatar: UIImageView, userFollowData: UILabel, userBio: UILabel, userLoginName: UILabel, userLocation: UILabel, tableView: UITableView) {
        afSession.request(requestData).responseJSON { (response) in
            switch response.result {
            case .success(let responseJSON) :
                let recievedJson = JSON(responseJSON)
                let userAvatr = recievedJson["\(PrivateUser.userAvatar)"].stringValue
                userName.text = recievedJson["\(PrivateUser.userName)"].stringValue
                userAvatar.kf.setImage(with: URL(string: userAvatr), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                userAvatar.layer.masksToBounds = false
                userAvatar.layer.cornerRadius = userAvatar.frame.height/2
                userAvatar.clipsToBounds = true
                userFollowData.text = "followers:  " + recievedJson["\(PrivateUser.userFollowers)"].stringValue + "  .  " + "following:  " + recievedJson["\(PrivateUser.userFollowing)"].stringValue
                userBio.text = recievedJson["\(PrivateUser.userBio)"].stringValue
                userLoginName.text = recievedJson["\(PrivateUser.userLoginName)"].stringValue
                userLocation.text  = recievedJson["\(PrivateUser.userLocation)"].stringValue
                tableView.isHidden = false
            case .failure(let error):
                print(error)
            }
        }
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.repositoriesViewTitle)", image: "Repositories" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.starredViewTitle)", image: "Startted" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.organizationsViewTitle)", image: "Organizations"))
    }
    func loggedInStatus (tableView: UITableView, conditionLabel: UILabel) {
    if isLoggedIn {
        conditionLabel.isHidden = true
    } else {
        tableView.isHidden = true
        conditionLabel.isHidden = false
    }
}
}
//MARK: - TableView
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  profileTableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ProfileTableViewCell
        cell.cellData(with: profileTableData[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
