//
//  EnterPricePopoverViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/9/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import FirebaseAuth



//Class to make a popover for making a new group
class ResetPasswordPopoverViewController: UIViewController {
    
    @IBOutlet weak var textBox: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textBox.textAlignment = .center
        textBox.adjustsFontForContentSizeCategory = true
        textBox.font = UIFont(name: "AvenirNext-Bold", size: 36)
        
        textBox.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.layer.cornerRadius = 10
        self.view.layer.masksToBounds = true
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        textBox.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func okButtonPressed(_ sender: Any) {
        textBox.endEditing(true)
        if let text = textBox?.text {
            if !text.isEmpty {
                FIRAuth.auth()?.sendPasswordReset(withEmail: self.textBox.text!, completion: nil)
            }
            dismiss(animated: true, completion: nil)

        }
        
    }
}
