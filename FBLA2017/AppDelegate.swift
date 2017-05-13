//  AppDelegate.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/7/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import FBSDKCoreKit
import GoogleSignIn
import Hero

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    let themeColor = UIColor.flatBlue

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.tintColor = themeColor

        FIRApp.configure()

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        return true
    }

//MARK :- Handle Facebook and Google Sign in
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let FBhandled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        let googleHandled = GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                              annotation: [:])

        return FBhandled || googleHandled
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)

        FIRAuth.auth()?.signIn(with: credential) { (_, error) in
            if let error = error {
                return
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)

                let viewController = storyboard.instantiateViewController(withIdentifier: "GroupVC")
                UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)

                UIApplication.shared.keyWindow?.rootViewController = viewController

            }

        }

        func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {

        }

    }
}

//MARK:- Defualt Animations
extension UICollectionView {
    public var heroModalAnimationType: HeroDefaultAnimationType {
        return .zoom
    }
}

extension UIViewController {
    public var heroModalAnimationType: HeroDefaultAnimationType {
        return .fade
    }
}

extension UINavigationController {
    public var heroNavigationAnimationType: HeroDefaultAnimationType {
        return .cover(direction: .up)
    }

}
