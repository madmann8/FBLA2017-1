//
//  EnterPricePopoverViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/9/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import FirebaseDatabase
//import Spring

protocol MakeGroupDelegate {
    func toMainView()
}

class MakeGroupPopoverViewController: UIViewController {

    @IBOutlet weak var textBox: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textBox.textAlignment = .center
        textBox.adjustsFontForContentSizeCategory = true
        textBox.font = UIFont(name: "AvenirNext-Bold", size: 36)

        textBox.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.view.layer.cornerRadius = 10
        self.view.layer.masksToBounds = true

    }

    var delegate: MakeGroupDelegate?

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
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
            } else {
//                let layer = self.view.layer as! SpringView
//                layer.animation = "squeezeDown"
//                layer.animate()
                          }
        dismiss(animated: true, completion: nil)
            delegate?.toMainView()

    }

    }
}
