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


class LoginViewController: UIViewController {
    
    
    var googleViewController:GoogleLoginViewController=GoogleLoginViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            GIDSignIn.sharedInstance().uiDelegate = googleViewController 
        GIDSignIn.sharedInstance().signIn()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="loginToGoogle" {
        GIDSignIn.sharedInstance().uiDelegate = segue.destination as! GIDSignInUIDelegate
        }
    }
    
    @IBAction func googleLoginButtonPressed(_ sender: GIDSignInButton) {
        performSegue(withIdentifier: "loginToGoogle", sender: nil)
    }
    
    
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
 
