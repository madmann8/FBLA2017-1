//
//  EnterPricePopoverViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/9/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol MakeGroupDelegate {
    func toMainView()
}
//Class to make a popover for making a new group
class MakeGroupPopoverViewController: UIViewController {
    
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
    
    var delegate: MakeGroupDelegate?
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        textBox.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func okButtonPressed(_ sender: Any) {
        textBox.endEditing(true)
        if let text = textBox?.text {
            if !text.isEmpty {
                let ref = FIRDatabase.database().reference().child("groups")
                let groupRef = ref.childByAutoId()
                groupRef.setValue(textBox?.text)
                currentUser.groupPath = groupRef.key
            }
            dismiss(animated: true, completion: nil)
            delegate?.toMainView()
            
        }
        
    }
}
