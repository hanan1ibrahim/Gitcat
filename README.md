### Hi there, This is ***GitCat*** - iOS Native App and based on [Github REST API][website] 👋

## App Features: 

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

## Important Notes:
  
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
