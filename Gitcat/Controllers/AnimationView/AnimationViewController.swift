//
//  AnimationViewController.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit
import Lottie

class AnimationViewController: UIViewController {
    let animationView = AnimationView()
    static let animation = "loader"
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        handleAnimation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    func startAnimation () {
        animationView.animation = Animation.named(AnimationViewController.animation)
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
    func handleAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.isLoggedIn {
                let tabBarView = TabBarViewController.instaintiate(on: .mainView)
                    self.navigationController?.pushViewController(tabBarView, animated: true)
            } else {
                let loginView = LoginViewController.instaintiate(on: .mainView)
                    self.navigationController?.pushViewController(loginView, animated: true)
            }
        }
    }

}
