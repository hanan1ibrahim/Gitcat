### Hi there, This is ***GitCat*** - iOS Native App and based on [Github REST API][website] 👋


# Description: 

       It is an application that simulates Github  website for Software Engineers allowing them to prefer repositories,  and important users accounts
   that help them to achieve what they want, and access them via safari link when user tap on the cell and share, follow and offline bookmark any user you want.

# User Stories :

* Animation view controller : As a user I want my app start with a beautiful animation that tell me the app us loading now.
* SignIn  view controller: As a user I want to login with my GitHub account to the app and display my profile.
* Users view controller:   As a user I want app that List Github users in a tableView with seachBar when choose user the app navigate us to safari web site,  when we hold on the cell the app open 4 actions menu:
                          1- bookmark 
                          2- follow
                          3- share
                          4- open in safari

* Repositories View Controller: As a user I want app that List Github Repositories in a tableView with searchBar when choose repo the app navigate us to safari web site, 
when we hold on the cell the app open 3 actions menu:
                         1- bookmark
                         2- share
                         3- open in safari

* Bookmarks View Controller : As a user I want app to list my users and repositories bookmarks list in a one table View and the availability to delete. 
* Profile View Controller :  
* Following and Followers View Controller: As as a user I want my following and followers list appear on the app from GitHub.
* Starred View Controller : as a user I want to  find the repositories that I prefer and I can access them via the browsers.
* Repositories View Controller : as a user I want to  find the repositories and I can access them via the browser.
* Organization View Controller : as a user I want to  find the organization and I can access them via the browser
* Settings View Controller : As a user I want to change the app language and change between dark or light mode.
                         1- Change Language
                         2- Dark Mode


# Services:

* Auth Service
    * auth.signin(user)
    * auth.signout(user)
* Github Service
    * Github Service.add(repos)
    * Github Service.delete(user)
* User Service
    * user.detail(profile)
    * user.detail(Following)



# Server / Backend :
## Models

User model
{
  user: {type: String, required: true, unique: true},
  email: {type: String, required: true, unique: true},
  password: {type: String, required: true},
  favorites: [{type: Schema.Types.ObjectId,ref:'Exit'}]
  userAgreement: {type: boolean, required: true, default: false}
}

Token model
struct AccessToken: Decodable {
  let accessToken: String
  let tokenType: String

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
  }
}



# Components

* AnimationPage 
* SignInPage
* ProfilePage
* FollowingPage
* BookmarksPage
* RepositoriesPage
* UsersPage
* SettingPage

| Component        | Permissions | Behavu 
| :---             |     ---   |   :---    |
| AnimationPage    | public      | Frist page |
| SignInPage       | anon only   | link to login, navigate to homepage after signIn.|
| Users Page       | anon & user | List Github users  ,navigate us to safari web site.|
| RepositoriesPage | anon & user | List Github Repositories , navigate us to safari web site.|
| BookmarksPage    | anon & user | List users and repositories bookmarks, and the availability to delete.|
| ProfilePage      | user only   | View user information appear on the app from GitHub.| 
| Followingand followersPage    | user only   |following and followers list appear on the app from GitHub..|
| StarredPage      | user only   |  User liked repositories stored in his github account.| 
| ReopsitoriesPage | user only   |  User repositories private or public.|
| Organization     |  user only  | If the user work at an organization it will appear in this place.|   
| SettingPage      | anon & user | Change the app language and change between dark or light mode.|


# App Features: 

- Explore all github users, repos.
- Explore your full Github profile with all informations.
- Explore and search github users.
- Explore  user Profile and Repositories by touch the cells.
- Bookmark any User or Repository  to The Bookmarks View when you longpress the cell or Tap on the Bookmark Button.
- You can delete Bookmarks Menu or Search History. 
- Open any User or Repository URL with Longpress menu.
- Explore and search for Public Repositories.
- Supporting Dark Mode.
- Supporting Arabic Language 100%

 ## App Technologies:
 
* App Current Version: V1.0
* Supported IOS : IOS 13 or above
* Swift Frameworks : UIKit - SafariServices - AuthenticationWS 
* DataStorage : Sqlite
* Third party Libraries : [Alamofire][Alamofire] - [Kingfisher][Kingfisher] - [Lottie][Lottie] - [IQKeyboard][IQKeyboard] - [SwiftyJSON][SwiftyJSON]
* Pattern : MVC
* Supported languages in App : English , Arabic ( not all titles translated it will be too soon!! )!

# Important Notes:
  
- open your terminal type 'cd' and drag the project folder and type this line if there is any erro at the beginning:
```
pod install
```
- Open Your Github account and  [Create New Github oAuth app][gitapp]
- Copy your "Client ID & Client secret" to
```
 Helpers > Authentication > AuthConstants >
```
- put the Authorization call back url this line :
```
 gitcatapp://
```
- put the homepage url any valid url
```
 https://github.com
```
- put the Authorization url in your URL Scheme if you want to make your own app
> if you don't do that choose try without github at the login View

- [using app ~~without authentication~~ reduce the API requests limit but with authentication you have 12500 request pre hour][githublink]

- If you face any issues report me

- **For development process client ID&Sercret are avaiable now you can try full version!**
*****************************************

[website]: https://docs.github.com/en/rest/guides
[gitapp]:  https://github.com/settings/applications/new
[githublink]:  https://docs.github.com/en/developers/apps/rate-limits-for-github-apps
[Alamofire]: https://cocoapods.org/pods/Alamofire
[Kingfisher]: https://cocoapods.org/pods/Kingfisher
[Lottie]: https://cocoapods.org/pods/lottie-ios
[IQKeyboard]: https://cocoapods.org/pods/IQKeyboardManagerSwift
[SkeletonView]: https://cocoapods.org/pods/SkeletonView
[SwiftyJSON]: https://cocoapods.org/pods/SwiftyJSON
[JGProgressHUD]: https://cocoapods.org/pods/JGProgressHUD
[Swift 5.3]: https://developer.apple.com/swift/
