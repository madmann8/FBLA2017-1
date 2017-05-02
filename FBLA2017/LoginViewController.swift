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

//TODO: CANT LOGIN FROM GOOGLE THEN SIWCT TO EMAIL

class LoginViewController: UIViewController,GIDSignInUIDelegate {
    
    var handle: FIRAuthStateDidChangeListenerHandle?

    var stackVC:EmailStackViewController?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        signInButton.colorScheme = .dark
//        GIDSignIn.sharedInstance().signIn()

        // TODO(developer) Configure the sign-in button look/feel
        // ...
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if user != nil {
                print(user?.displayName)
                print(user?.uid)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let viewController = storyboard.instantiateViewController(withIdentifier: "MainView")
                UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                
                UIApplication.shared.keyWindow?.rootViewController = viewController
                

            }
        }
        
    }
    
    @IBAction func emailSwitchChanged(_ sender: UISegmentedControl) {
        stackVC?.updateVisible(signUp: sender.selectedSegmentIndex==1)
    }
    
    
    @IBAction func submitButtonPressed() {
        stackVC?.upload()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toEmailContainer"{
            let vc = segue.destination as! EmailStackViewController
            self.stackVC=vc
            vc.largeVC=self
        }
    }
    @IBAction func googleSignInButtonPressed() {
//        GIDSignIn.sharedInstance().signIn()

    }
    
    @IBOutlet weak var signInButton: GIDSignInButton!
       
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let loginManager=FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
        }
        
        
    }
}
 
