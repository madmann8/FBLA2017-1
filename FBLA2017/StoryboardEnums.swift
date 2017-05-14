//
//  StoryboardEnums.swift
//  FBLA2017
//
//  Created by Luke Mann on 5/14/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardSceneType {
    static var storyboardName: String { get }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
    func viewController() -> UIViewController {
        return Self.storyboard().instantiateViewControllerWithIdentifier(withIdentifier: self.rawValue)
    }
    static func viewController(identifier: Self) -> UIViewController {
        return identifier.viewController()
    }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
    func performSegue<S: StoryboardSegueType where S.RawValue == String>(segue: S, sender: AnyObject? = nil) {
        performSegue(withIdentifier: segue.rawValue, sender: sender)
    }
}

enum StoryboardScene {
    enum LaunchScreen: StoryboardSceneType {
        static let storyboardName = "LaunchScreen"
    }
    enum Main: String, StoryboardSceneType {
        static let storyboardName = "Main"
        
        static func initialViewController() -> FBLA2017.LoginViewController {
            guard let vc = storyboard().instantiateInitialViewController() as? FBLA2017.LoginViewController else {
                fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
            }
            return vc
        }
        
        case DynamicViewControllerScene = "DynamicViewController"
        static func instantiateDynamicViewController() -> FBLA2017.EnterPricePopoverViewController {
            guard let vc = StoryboardScene.Main.DynamicViewControllerScene.viewController() as? FBLA2017.EnterPricePopoverViewController
                else {
                    fatalError("ViewController 'DynamicViewController' is not of the expected class FBLA2017.EnterPricePopoverViewController.")
            }
            return vc
        }
        
        case GroupVCScene = "GroupVC"
        static func instantiateGroupVC() -> UINavigationController {
            guard let vc = StoryboardScene.Main.GroupVCScene.viewController() as? UINavigationController
                else {
                    fatalError("ViewController 'GroupVC' is not of the expected class UINavigationController.")
            }
            return vc
        }
        
        case LoginScene = "Login"
        static func instantiateLogin() -> FBLA2017.LoginViewController {
            guard let vc = StoryboardScene.Main.LoginScene.viewController() as? FBLA2017.LoginViewController
                else {
                    fatalError("ViewController 'Login' is not of the expected class FBLA2017.LoginViewController.")
            }
            return vc
        }
        
        case MainViewScene = "MainView"
        static func instantiateMainView() -> FBLA2017.TabBarController {
            guard let vc = StoryboardScene.Main.MainViewScene.viewController() as? FBLA2017.TabBarController
                else {
                    fatalError("ViewController 'MainView' is not of the expected class FBLA2017.TabBarController.")
            }
            return vc
        }
        
        case MakeGroupScene = "MakeGroup"
        static func instantiateMakeGroup() -> FBLA2017.MakeGroupPopoverViewController {
            guard let vc = StoryboardScene.Main.MakeGroupScene.viewController() as? FBLA2017.MakeGroupPopoverViewController
                else {
                    fatalError("ViewController 'MakeGroup' is not of the expected class FBLA2017.MakeGroupPopoverViewController.")
            }
            return vc
        }
        
        case OtherUserProfileScene = "OtherUserProfile"
        static func instantiateOtherUserProfile() -> FBLA2017.OtherUserProfileViewController {
            guard let vc = StoryboardScene.Main.OtherUserProfileScene.viewController() as? FBLA2017.OtherUserProfileViewController
                else {
                    fatalError("ViewController 'OtherUserProfile' is not of the expected class FBLA2017.OtherUserProfileViewController.")
            }
            return vc
        }
        
        case ProfileScene = "Profile"
        static func instantiateProfile() -> FBLA2017.ProfileViewController {
            guard let vc = StoryboardScene.Main.ProfileScene.viewController() as? FBLA2017.ProfileViewController
                else {
                    fatalError("ViewController 'Profile' is not of the expected class FBLA2017.ProfileViewController.")
            }
            return vc
        }
        
        case ResetPWScene = "ResetPW"
        static func instantiateResetPW() -> FBLA2017.ResetPasswordPopoverViewController {
            guard let vc = StoryboardScene.Main.ResetPWScene.viewController() as? FBLA2017.ResetPasswordPopoverViewController
                else {
                    fatalError("ViewController 'ResetPW' is not of the expected class FBLA2017.ResetPasswordPopoverViewController.")
            }
            return vc
        }
        
        case SelectLocationViewControllerScene = "SelectLocationViewController"
        static func instantiateSelectLocationViewController() -> FBLA2017.SelectLocationViewController {
            guard let vc = StoryboardScene.Main.SelectLocationViewControllerScene.viewController() as? FBLA2017.SelectLocationViewController
                else {
                    fatalError("ViewController 'SelectLocationViewController' is not of the expected class FBLA2017.SelectLocationViewController.")
            }
            return vc
        }
        
        case WalkthroughPageVCScene = "WalkthroughPageVC"
        static func instantiateWalkthroughPageVC() -> FBLA2017.WalkthroughPageViewController {
            guard let vc = StoryboardScene.Main.WalkthroughPageVCScene.viewController() as? FBLA2017.WalkthroughPageViewController
                else {
                    fatalError("ViewController 'WalkthroughPageVC' is not of the expected class FBLA2017.WalkthroughPageViewController.")
            }
            return vc
        }
        
        case DetailMiddleScene = "detailMiddle"
        static func instantiateDetailMiddle() -> FBLA2017.InfoContainerViewController {
            guard let vc = StoryboardScene.Main.DetailMiddleScene.viewController() as? FBLA2017.InfoContainerViewController
                else {
                    fatalError("ViewController 'detailMiddle' is not of the expected class FBLA2017.InfoContainerViewController.")
            }
            return vc
        }
        
        case DetailTopScene = "detailTop"
        static func instantiateDetailTop() -> FBLA2017.MoreDetailsViewController {
            guard let vc = StoryboardScene.Main.DetailTopScene.viewController() as? FBLA2017.MoreDetailsViewController
                else {
                    fatalError("ViewController 'detailTop' is not of the expected class FBLA2017.MoreDetailsViewController.")
            }
            return vc
        }
        
        case MainPVCScene = "mainPVC"
        static func instantiateMainPVC() -> FBLA2017.PageViewController {
            guard let vc = StoryboardScene.Main.MainPVCScene.viewController() as? FBLA2017.PageViewController
                else {
                    fatalError("ViewController 'mainPVC' is not of the expected class FBLA2017.PageViewController.")
            }
            return vc
        }
        
        case PulleyScene = "pulley"
        static func instantiatePulley() -> FBLA2017.FirstContainerViewController {
            guard let vc = StoryboardScene.Main.PulleyScene.viewController() as? FBLA2017.FirstContainerViewController
                else {
                    fatalError("ViewController 'pulley' is not of the expected class FBLA2017.FirstContainerViewController.")
            }
            return vc
        }
        
        case SbImageScene = "sbImage"
        static func instantiateSbImage() -> FBLA2017.ImageViewController {
            guard let vc = StoryboardScene.Main.SbImageScene.viewController() as? FBLA2017.ImageViewController
                else {
                    fatalError("ViewController 'sbImage' is not of the expected class FBLA2017.ImageViewController.")
            }
            return vc
        }
        
        case WalkthroughScene = "walkthrough"
        static func instantiateWalkthrough() -> FBLA2017.WalkthroughSinglePageViewController {
            guard let vc = StoryboardScene.Main.WalkthroughScene.viewController() as? FBLA2017.WalkthroughSinglePageViewController
                else {
                    fatalError("ViewController 'walkthrough' is not of the expected class FBLA2017.WalkthroughSinglePageViewController.")
            }
            return vc
        }
    }
}

enum StoryboardSegue {
    enum Main: String, StoryboardSegueType {
        case ContainerToChat = "containerToChat"
        case LoginToGroups = "loginToGroups"
        case LoginToWalkthrough = "loginToWalkthrough"
        case MainWTtoPages = "mainWTtoPages"
        case ProfileToFavorites = "profileToFavorites"
        case ProfileToSelling = "profileToSelling"
        case ShowPageVC = "showPageVC"
        case ToChat = "toChat"
        case ToContainedChat = "toContainedChat"
        case ToDirectChat = "toDirectChat"
        case ToEmailContainer = "toEmailContainer"
        case ToFavorites = "toFavorites"
        case ToGlobalChat = "toGlobalChat"
        case ToSecondContainer = "toSecondContainer"
        case ToSelling = "toSelling"
    }
}

private final class BundleToken {}
