//
//  PrivateOrgsViewController.swift
//  Gitcat
//
//  Created by HANAN on 14/05/1443 AH.
//

import UIKit
import Alamofire
import SafariServices

class PrivateOrgsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Varibles
    let spinner = UIActivityIndicatorView()
    let afSession: Session = {
        let interceptor = RequestIntercptor()
        return Session(
            interceptor: interceptor)
    }()
    var orgsModel = [Orgs]()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadingIndicator()
        initData()
        configureUI()
    }
    // MARK: - Functions
    
    func loadingIndicator() {
        spinner.style = UIActivityIndicatorView.Style.large
        spinner.center = view.center
        view.addSubview(spinner)
    }
    func initData() {
        getOrgsList()
    }
    func configureUI() {
        title = Titles.organizationsViewTitle
    }
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    func presentAlert(title: String, msg: String, btnTitle: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: btnTitle, style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    func getOrgsList() {
        spinner.startAnimating()
        let requestURL = Router.privateOrgsAPILinl
        afSession.request(requestURL).responseDecodable(of: [Orgs].self, completionHandler: { response in
            switch response.result {
            case .success(_):
                guard let orgs = response.value else {return}
                self.orgsModel = orgs
                self.tableView.reloadData()
                self.spinner.stopAnimating()
            case .failure(let error):
                self.presentAlert(title: "Error", msg: error.localizedDescription, btnTitle: "Ok")
            }
        })
    }
}

// MARK: -TableView
extension PrivateOrgsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orgsModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orgsCell", for: indexPath)
        let model = orgsModel[indexPath.row]
        cell.textLabel?.text = model.orgName
        cell.detailTextLabel?.text = model.orgDescription
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

