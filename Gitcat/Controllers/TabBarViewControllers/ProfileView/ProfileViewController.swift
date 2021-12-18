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
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLogin: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userFollowers: UILabel!
    //MARK: - Data Proprties
    var privateProfileModel = [ProfileTableData]()
    var userRepository = [Repository]()
    //MARK: - Properties
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
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initViewData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfUserLoggedIn()
        loadProfileDataFromSwiftyJSON()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loadProfileDataFromSwiftyJSON()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadProfileDataFromSwiftyJSON()
    }
    //MARK: - UI Functions
    func initUI() {
        initTitles()
        initCenterLabel()
        tableViewData()
        gestureRecoginzer()
    }
    func initViewData() {
        fetchData()
    }
    func gestureRecoginzer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToFollowers))
        userFollowers.addGestureRecognizer(tapGesture)
        userFollowers.isUserInteractionEnabled = true
    }
    typealias ActionCompletion = ((UIAlertAction) -> Void)?

    func sheetWithTwoOptions(title: String, msg: String,
                               btnsTitles: [String],
                                btn1Action: ActionCompletion = nil,
                                btn2Action: ActionCompletion = nil)  {
         let actionSheet = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
         let actBtn1 = UIAlertAction(title: btnsTitles[0], style: .default, handler: btn1Action)
         let actBtn2 = UIAlertAction(title: btnsTitles[1], style: .default, handler: btn2Action)
        let cancelBtn = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
         actionSheet.addAction(actBtn1)
         actionSheet.addAction(actBtn2)
        actionSheet.addAction(cancelBtn)
         self.present(actionSheet, animated: true)
     }
    @objc func navigateToFollowers() {
        sheetWithTwoOptions(title: "Choose", msg: "", btnsTitles: ["Followers", "Following"]) { alert in
            let followersVC = FollowersViewController.instaintiate(on: .mainView)
            self.navigationController?.pushViewController(followersVC, animated: true)
        } btn2Action: { alert in
            let followersVC = FollowingViewController.instaintiate(on: .mainView)
            self.navigationController?.pushViewController(followersVC, animated: true)
        }
    }
    func initCenterLabel() {
        conditionLabel.text = Titles.notLoggedInUser
    }
    func initTitles() {
        title = Titles.profileViewTitle
        tabBarItem.title = Titles.profileViewTitle
    }
    func tableViewData() {
        tableView.tableFooterView = UIView()
        tableView.isHidden = true
    }
    func checkIfUserLoggedIn() {
        if isLoggedIn {
            conditionLabel.isHidden = true
        } else {
            tableView.isHidden = true
            conditionLabel.isHidden = false
        }
    }
    func presentAlert(title: String, msg: String, btnTitle: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: btnTitle, style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }

    //MARK: - Data Functions
    func addTableCellsTitlesAndImages() {
        privateProfileModel.append(ProfileTableData(cellTitle: "\(Titles.repositoriesViewTitle)", cellImage: "Repositories" ))
        privateProfileModel.append(ProfileTableData(cellTitle: "\(Titles.starredViewTitle)", cellImage: "Startted" ))
        privateProfileModel.append(ProfileTableData(cellTitle: "\(Titles.organizationsViewTitle)", cellImage: "Organizations"))
    }
    func loadProfileDataFromSwiftyJSON() {
        let requestURL = Router.privateUserAPIlink
        afSession.request(requestURL).responseJSON { [self] (response) in
            switch response.result {
            case .success(let responseJSON) :
                let recievedJson = JSON(responseJSON)
                let userAvatr = recievedJson["\(PrivateUser.userAvatar)"].stringValue
                userName.text = recievedJson["\(PrivateUser.userName)"].stringValue
                userAvatar.kf.setImage(with: URL(string: userAvatr), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                userAvatar.layer.masksToBounds = false
                userAvatar.layer.cornerRadius = userAvatar.frame.height/2
                userAvatar.clipsToBounds = true
                userFollowers.text = "followers:  " + recievedJson["\(PrivateUser.userFollowers)"].stringValue + "  .  " + "following:  " + recievedJson["\(PrivateUser.userFollowing)"].stringValue
                userBio.text = recievedJson["\(PrivateUser.userBio)"].stringValue
                userLogin.text = recievedJson["\(PrivateUser.userLoginName)"].stringValue
                userLocation.text  = recievedJson["\(PrivateUser.userLocation)"].stringValue
                tableView.isHidden = false
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchData() {
        loadProfileDataFromSwiftyJSON()
        addTableCellsTitlesAndImages()
    }
}
//MARK: - TableView
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  privateProfileModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        let profileModel = privateProfileModel[indexPath.row]
        cell.textLabel?.text = profileModel.cellTitle
        cell.imageView?.image = UIImage(named: profileModel.cellImage)
        cell.imageView?.layer.cornerRadius = 10
        cell.imageView?.clipsToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let vc = PrivateRepositoriesViewController.instaintiate(on: .mainView)
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = PrivateStarredReposViewController.instaintiate(on: .mainView)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = PrivateOrgsViewController.instaintiate(on: .mainView)
            navigationController?.pushViewController(vc, animated: true)
        }
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
