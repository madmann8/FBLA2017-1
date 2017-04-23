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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.flatWatermelon
        passwordTextView.isSecureTextEntry=true
        nameTextView.delegate=self
        emailTextView.delegate=self
        passwordTextView.delegate=self
        setupBorder(tv: emailTextView)
        setupBorder(tv: nameTextView)
        setupBorder(tv: passwordTextView)

        


        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var emailTextView: UITextView!
    @IBOutlet weak var passwordTextView: UITextView!
    
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
            FIRAuth.auth()?.createUser(withEmail: emailTextView.text, password: emailTextView.text) { (user, error) in
                if let error=error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)

                }
                else {
                    let ref=FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("displayName")
                    ref.setValue("\(self.nameTextView.text!)")
                    }
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                }
                
        }
        else {
            FIRAuth.auth()?.signIn(withEmail: self.emailTextView.text, password: self.passwordTextView.text) { (user, error) in
                if let error=error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)

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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    

    
}
    
    extension EmailStackViewController:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if (text == "\n") {
                textView.resignFirstResponder()
            }
            return true
        }
        func setupBorder(tv:UITextView){
            tv.layer.borderColor=UIColor.flatGrayDark.cgColor
            tv.layer.borderWidth = 0.5
        }
    }
