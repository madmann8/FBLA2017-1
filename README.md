# Yard Sale - A chat based yard sale

![App logo](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/FBLA2017/Assets.xcassets/AppIcon.appiconset/AppIcon-60%403x.png?token=AbCv2DDxx9EAtd3663E-V4BUqiYtXN33ks5ZFgjFwA%3D%3D)


## About

### Prompt
> Create a mobile application that would allow a platform for a digital yard sale to raise funds to attend NLC. The app should allow for the donation of items, including picture, suggested price, and a rating for the condition of the item. The app should allow for interaction/comments on the items. Code should be error free.

### App Features
* Easy login using Google, Facebook, or email.
* Easily donate and sell items by providing item infomation including title, description,  condition, images, location, and prices. 
* Quickly browse items and view detailed information about those items. 
* Contact users in a chat based interface as well as engage in global chats for items
* A fully functional backend and authentication system
* Join local groups or use the global group for targeted fund raising
* A walkthrough for easy app usage
* Informatino about the benifets of donating to FBLA

### Services Used
* Google OAuth for Google sign in
* Facebook developer tools for Facebook login
* Google Firebase for database
* Google Firebase for authentication (passwords and sentive information can never be viewed)
* Other libraries shown in Podfile and are all licensed under MIT license

### GUI Screenshots
[Download PDF](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/GUIScreenshots.pdf)

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
5. Go to the top left corner, select `FBLA2017` as the Scheme, chose a device to run the app on,  and press the run button (play button)
![Select Run](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/Screen%20Shot%202017-05-05%20at%203.38.44%20PM.png)
6. If signing errors occur, please see the Signing Errors section     
7. While running the app, you can set the location of the simulator by selecting the location button in the bottom bar. ![Select Locatoin](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/FullSizeRender.jpg)

### Signing Errors
If a signing error occurs while compiling or running an app please do the following:

1. Go to Xcode -> Preferences, and select Accounts. Here, select the + button in the bottom left corner and sign into you're Apple Developer Account. If you do not have an Apple Developer Account, follow [these instuctions](https://9to5mac.com/2016/03/27/how-to-create-free-apple-developer-account-sideload-apps/) to make an account 
2.  Select FBLA2017 (project file) in the Project Navigator (located on the left)
3. Select the "General" tab and change the bundle identifier 
<!--4. Under Identitiy: Change the bundle ID, replacing com.namehere with any domain that you would like to use
![Select Run](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/Screen%20Shot%202017-05-13%20at%209.10.51%20AM.png)-->
4. Under Signing: Change the team t
![Select Run](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/Screen%20Shot%202017-05-13%20at%209.13.50%20AM.png)
5. Run the app 
6. If all fails, redo the Instructions for Testing and run on a simulator











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


