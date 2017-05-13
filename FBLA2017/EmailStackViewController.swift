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
import ChameleonFramework

//class the represnt the embeded view in the LoginVIewController
class EmailStackViewController: UIViewController {

    var largeVC: UIViewController?

    var loggingIn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.flatWatermelon
        nameTextView.delegate = self
        emailTextView.delegate = self
        passwordTextView.delegate = self
        nameTextView.textColor = UIColor(red: 0, green: 0, blue: 1 / 99_999, alpha: 1.0)
        emailTextView.textColor = UIColor(red: 0, green: 0, blue: 1 / 99_999, alpha: 1.0)
        passwordTextView.textColor = UIColor(red: 0, green: 0, blue: 1 / 99_999, alpha: 1.0)
        setupBorder(tv: emailTextView!)
        setupBorder(tv: nameTextView!)
        setupBorder(tv: passwordTextView!)

    }


    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!

    func updateVisible(signUp: Bool) {
        if signUp {
            nameTextView.isHidden = true
        } else {
            nameTextView.isHidden = false
        }
    }

    func upload() {
        if !nameTextView.isHidden {
            FIRAuth.auth()?.createUser(withEmail: emailTextView.text!, password: passwordTextView.text!) { (_, error) in
                if let error = error {
                    ErrorGenerator.presentError(view: self.largeVC!, type: "Sign Up", error: error)
                } else {
                    self.largeVC?.performSegue(withIdentifier: "loginToGroups", sender: nil)
                    }

                }

        } else {
            print(self.passwordTextView.text!)
            FIRAuth.auth()?.signIn(withEmail: emailTextView.text!, password: passwordTextView.text!) { (_, error) in
                     if let error = error {
                  ErrorGenerator.presentError(view: self.largeVC!, type: "Login", error: error)

                } else {
                        self.largeVC?.performSegue(withIdentifier: "loginToGroups", sender: nil)
                        self.loggingIn = true

                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToGroups" {
            if !loggingIn {
            let vc = segue.destination as! GroupsTableViewController
            vc.nameToUpload = "\(self.nameTextView.text!)"
            }
        }
    }

}

    extension EmailStackViewController:UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
        func setupBorder(tv: UITextField) {
            tv.layer.borderColor = UIColor.flatGrayDark.cgColor
            tv.layer.borderWidth = 0.5
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField.textColor == UIColor(red: 0, green: 0, blue: 1 / 99_999, alpha: 1.0) {
                textField.text = nil
                textField.textColor = UIColor.black
            }
        }
    }
