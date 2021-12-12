//
//  Titles.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import Foundation

struct Titles {
    
    //MARK:- LoginViewTitles
    
    static let signInWithGithubTitle  = "Sign in with GitHub".localized()
    static let guestModeWithoutGithubTitle = "Try without Github!".localized()
    static let byContinue            = "by continue any way you will face API usage limit issues!".localized()
    static let loginOptions               = "Login Options".localized()
    static let makeSure              = "make sure you read the README file and fetch your client ID & client secret to Login with Github and avoid 404 web error or Try without!!".localized()
    static let bySign                = "By sigining in you accept Github".localized()
    static let continueLabel             = "Continue!".localized()
    static let termsOfUseTitle        = "Terms of use".localized()
    static let privacyPolicyTitle     = "Privacy policy".localized()
    static let annd                   = "and".localized()
    
    //MARK:- Settings View Title Labels
    
    static let darkMode              = "Dark Mode".localized()
    static let logOut                = "Log Out".localized()
    static let langauge              = "Change to English".localized()
    static let generalHeaderTitle = "General".localized()
    static let policyHeaderTitle = "Policy".localized()
    static let languageHeaderTitle = "Language".localized()
    static let accountHeaderTitle =   "Account".localized()
    
    //MARK:- Views Title Labels
    
    static let homeViewTitle          = "Home".localized()
    static let usersViewTitle        = "Users".localized()
    static let profileViewTitle       = "Profile".localized()
    static let bookmarksViewTitle    = "Bookmarks".localized()
    static let repositoriesViewTitle = "Repositories".localized()
    static let commitsViewTitle      = "Commits".localized()
    static let settingsViewTitle     = "Settings".localized()
    static let issuesViewTitle      = "Issues".localized()
    static let starredViewTitle               = "Starred".localized()
    static let organizationsViewTitle = "Organizations".localized()
    static let resultsViewTitle =        "Results".localized()
    
    //MARK:- No Content Title Labels
    static let notLoggedInUser             = "Not Signed In".localized()
    
    //MARK:- Before Search Title Labels
    static let searchForUsers           = "Search For Users".localized()
    static let searchForRepos           = "Search For Repos".localized()
    static let searchForBookmarks        = "Search in Bookmarks".localized()
    static let searchGithub              = "Search in Github".localized()
    static let searchIssues              = "Search for Issues".localized()
    
    //MARK:- Sheets Title Label
  
    static let share                    = "Share".localized()
    static let saveImage                = "Save Image".localized()
    static let openInSafari             = "Open with Safari".localized()
    static let cancel                = "Cancel".localized()
    static let bookmark              = "Bookmark".localized()
    static let follow              = "Follow".localized()
    static let unfollow              = "UnFollow".localized()
    static let urlTitle                   = "URL".localized()

    //MARK:- Home View Titles Labels
    
    static let gitHubURL              = "Github Web".localized()
    static let featuresTitle           = "Features".localized()
    static let state                  = "State"
    static let projectRepoTitle       = "Repo".localized()
    static let authenticatedModeTitle = "Authenticated User Mode".localized()
    static let guestModeTitle         = "Guest Mode".localized()
    
    //MARK:- Others Title Labels
    
    static let searchPlacholder      = " Search...".localized()
}

extension String {
    func localized () -> String {
        return NSLocalizedString(self, tableName: "localize", bundle: .main, value: self, comment: self
        )
    }
}
