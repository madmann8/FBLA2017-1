//
//  LoginViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/14/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn
import ChameleonFramework
import Presentr

//View Controller for the login page
class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    var stackVC: EmailStackViewController?
    
    var hasLoaded = false
    
    @IBOutlet weak var submitButton: UIButton!
    
    var hasFailedLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = submitButton.frame.height / 2
        GIDSignIn.sharedInstance().uiDelegate = self
        signInButton.colorScheme = .dark
        
    }
    
    @IBAction func updatePasswordButtonPressed() {
//        let config = SCLAlertView.SCLAppearance(
//            kTitleFont: UIFont(name: "AvenirNext-Regular", size: 20)!,
//            kTextFont: UIFont(name: "AvenirNext-Regular", size: 14)!,
//            kButtonFont: UIFont(name: "AvenirNext-DemiBold", size: 14)!
//        )
//        let resetView = SCLAlertView()
//        let textField = resetView.addTextField("Enter email")
//        resetView.addButton("Reset") {
//            FIRAuth.auth()?.sendPasswordReset(withEmail: textField.text!, completion: nil)
//        }
//        resetView.showEdit("Reset Password", subTitle: "An email will be sent with reset instructions")
        let width = ModalSize.fluid(percentage: 0.7)
        let height = ModalSize.fluid(percentage: 0.3)
        let center = ModalCenterPosition.center
        
        let presentationType = PresentationType.custom(width: width, height: height, center: center
        )
        let dynamicSizePresenter = Presentr(presentationType: presentationType)
        let dynamicVC = storyboard!.instantiateViewController(withIdentifier: "ResetPW") as! ResetPasswordPopoverViewController
        customPresentViewController(dynamicSizePresenter, viewController: dynamicVC, animated: true, completion: nil)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if !hasLoaded {
            if UserDefaults.standard.bool(forKey: "hasLoadedWalkthrough") {
                loadViews()
            } else {
                UserDefaults.standard.set(true, forKey: "hasLoadedWalkthrough")
                self.performSegue(withIdentifier: "loginToWalkthrough", sender: nil)
            }
        }
        hasLoaded = true
    }
    
    @IBAction func emailSwitchChanged(_ sender: UISegmentedControl) {
        stackVC?.updateVisible(signUp: sender.selectedSegmentIndex == 1)
        if submitButton.title(for: .normal)=="Sign Up"{
            submitButton.setTitle("Log In", for: .normal)
        } else {
            submitButton.setTitle("Sign Up", for: .normal)
        }
        
    }
    
    @IBAction func submitButtonPressed() {
        stackVC?.upload()
        
    }
    
    func loadViews() {
        handle = FIRAuth.auth()?.addStateDidChangeListener { (_, user) in
            if user != nil {
                if !self.hasFailedLogin {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let viewController = storyboard.instantiateViewController(withIdentifier: "MainView")
                    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                    
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                }
                
            } else {
                self.hasFailedLogin = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toEmailContainer"{
            let vc = segue.destination as! EmailStackViewController
            self.stackVC = vc
            vc.largeVC = self
        }
    }
    @IBAction func googleSignInButtonPressed() {
        
    }
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (_, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (_, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupVC") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
        }
        
    }
}
