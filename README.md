# Yard Sale - A chat based yard sale

![App logo](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/FBLA2017/Assets.xcassets/AppIcon.appiconset/AppIcon-60%403x.png?token=AbCv2DDxx9EAtd3663E-V4BUqiYtXN33ks5ZFgjFwA%3D%3D)


- [Yard Sale - A chat based yard sale](#yard-sale---a-chat-based-yard-sale)
  * [About](#about)
    + [Prompt](#prompt)
    + [App Features](#app-features)
    + [Services Used](#services-used)
    + [GUI Screenshots](#gui-screenshots)
    + [Tips for using Yard Sale](#tips-for-using-yard-sale)
  * [Installation](#installation)
    + [Prerequisites](#prerequisites)
    + [Instructions for testing](#instructions-for-testing)
    + [Signing Errors](#signing-errors)
    + [Other Errors](#other-errors)

## About

### Prompt
> Create a mobile application that would allow a platform for a digital yard sale to raise funds to attend NLC. The app should allow for the donation of items, including picture, suggested price, and a rating for the condition of the item. The app should allow for interaction/comments on the items. Code should be error free.

### App Features
* Easy login using Google, Facebook, or email.
* Easily donate and sell items by providing item information including title, description,  condition, images, location, and prices. 
* Quickly browse items and view detailed information about those items. 
* Contact users in a chat based interface as well as engage in global chats for items
* A fully functional backend and authentication system
* Join local groups or use the global group for targeted fundraising
* A walkthrough for easy app usage
* Information about the benefits of donating to FBLA

### Services Used
* Google OAuth for Google sign in
* Facebook developer tools for Facebook login
* Google Firebase for database
* Google Firebase for authentication (passwords and sensitive information can never be viewed)
* Other libraries are shown in Podfile and are all licensed under MIT license
* [Icon 8](https://icons8.com) for Tabbar Icons
* [Popcorn Art](http://www.flaticon.com/authors/popcorns-arts?group_id=180&order_by=2) for app sign as well as walktrough images

### GUI Screenshots
[Download PDF](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/GUIScreenshots.pdf)

### Tips for using Yard Sale
* If you would not like to make an account, a testing account has been created to highlight some features. The email is` test@lukejmann.com` and the password is `Test1234`
* The Global group has been created with sample items
* To purchase an item, reach out to the seller via "Seller". If you would like to just ask a question, ask the question in the "Item" chat
* If you have successfully sold an item, select that item in the browse section (or in the "Selling" section of the profile section)
* Tap the center of the screen while on an item (in the browse section) to go to the next item



## Installation
### Prerequisites
* [Xcode 8.3](https://itunes.apple.com/us/app/xcode/id497799835?mt=12)(latest, but it should work with 8.1+)
* An internet connection
* iPhone 7 or 7 plus simulators installed or a physical iPhone running iOS 10.0 +

### Instructions for testing
1. Open Xcode and select Source Control -> Checkout
2. Under "Or enter a repository location:"  paste `https://github.com/lukejmann/FBLA2017.git` and select "Next".
3. Select `master` branch and select "Next".
4. Select a location to store the project, select "Download", and wait for the project to download and open
5. Go to the top left corner, select `FBLA2017` as the Scheme; select iPhone 7, iPhone 7 Plus, or an attached iPhone to run the app on; and press the run button (play button)
![Select Run](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/Screen%20Shot%202017-05-05%20at%203.38.44%20PM.png)
6. If signing errors occur (this is expected), please see the Signing Errors section
7. While running the app, you can set the location of the simulator by selecting the location button in the bottom bar. ![Select Locatoin](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/FullSizeRender.jpg)

### Signing Errors
If a signing error occurs while compiling or running an app please do the following:

1. Go to Xcode -> Preferences, and select Accounts. Here, select the + button in the bottom left corner and sign into your Apple Developer Account. If you do not have an Apple Developer Account, follow [these instuctions](https://9to5mac.com/2016/03/27/how-to-create-free-apple-developer-account-sideload-apps/) to make an account 
2.  Select FBLA2017 (project file) in the Project Navigator (located on the left)
3. Select the "General" tab and change the bundle identifier 
4. Under Identity: Change the bundle ID, replacing com.namehere with any unique domain that you would like to use
![Select Run](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/Screen%20Shot%202017-05-13%20at%209.10.51%20AM.png)
5. If there are any issues at this point, please follow [these instructions](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppStoreDistributionTutorial/CreatingYourTeamProvisioningProfile/CreatingYourTeamProvisioningProfile.html)
4. Under Signing: Change the team to the newly created profile. 
![Select Run](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/Screen%20Shot%202017-05-13%20at%209.13.50%20AM.png)
5. Run the app 
6. If all fails, redo the Instructions for Testing and run on a simulator

### Other Errors 
| Issue | Solution |
|-------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| When running on a physical device, the developer is not trusted.  | Go to Settings -> General -> Device-> And select trust for your developer profile |
| App appears as a black screen | If running on a simulator, the simulator may be booting up, otherwise, try running the app again |
| "The run destination is not valid" | Ensure that the app running on an iOS device or simulator that is iOS 10.2  |
| I can't see the project navigator  | Go to View -> Navigators and select Project Navigator  | 
| Location does not load in app |  While running the app, you can set the location of the simulator by selecting the location button in the bottom bar. ![Select Locatoin](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/FullSizeRender.jpg) |






<!--### Steps
1. 
 If you have [git](https://git-scm.com) : 
 Run  `git clone https://github.com/lukejmann/FBLA2017.git` in the desired installation folder.
 
 OR
 
 If you do not have git, 
  press the download ZIP button (⬆️) and extract the ZIP file to the desired folder.

2. Open `FBLA2017.xcworkspace`
<!---7. Go to the top left corner, select `FBLA2017` as the Scheme, chose a device to run the app on,  and press the run button (play button)
![Select Run](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/Screen%20Shot%202017-05-05%20at%203.38.44%20PM.png)
8.  If the app is being run on a physical device, the app and developer profile must be approved in the settings menu of the device (Settings –> General –> Device Management)-->
