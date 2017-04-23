    //
//  EmailStackViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/15/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import FirebaseAuth
    import FirebaseDatabase

class EmailStackViewController: UIViewController {
    
    var largeVC:UIViewController?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.flatWatermelon
        nameTextView.delegate=self
        emailTextView.delegate=self
        passwordTextView.delegate=self
        setupBorder(tv: emailTextView!)
        setupBorder(tv: nameTextView!)
        setupBorder(tv: passwordTextView!)

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    
    func updateVisible(signUp:Bool){
        if signUp{
            nameTextView.isHidden=true
        }
        else {
            nameTextView.isHidden=false
        }
    }
    
    func upload() {
        if !nameTextView.isHidden{
            FIRAuth.auth()?.createUser(withEmail: emailTextView.text!, password: emailTextView.text!) { (user, error) in
                if let error=error {
                    ErrorGenerator.presentError(view: self.largeVC!, type: "Sign Up", error: error)
                }
                else {
                    let ref=FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("displayName")
                    ref.setValue("\(self.nameTextView.text!)")
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    }

                    
                }
                
        }
        else {
            FIRAuth.auth()?.signIn(withEmail: self.emailTextView.text!, password: self.passwordTextView.text!) { (user, error) in
                if let error=error {
                  ErrorGenerator.presentError(view: self.largeVC!, type: "Login", error: error)

                }
                else {
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                        self.dismiss(animated: true, completion: nil)
                    }

                }
            }
        }
    }

    

    
}
    
    extension EmailStackViewController:UITextFieldDelegate{
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
        func setupBorder(tv:UITextField){
            tv.layer.borderColor=UIColor.flatGrayDark.cgColor
            tv.layer.borderWidth = 0.5
        }
    }
