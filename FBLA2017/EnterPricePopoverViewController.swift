//
//  EnterPricePopoverViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/9/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import Money

protocol EnterPriceDelegate {
    func retrievePrice(price: Int)
}

class EnterPricePopoverViewController: UIViewController {

    @IBOutlet weak var moneyTextBox: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.blue
        moneyTextBox.delegate=self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var delegate:EnterPriceDelegate? = nil

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EnterPricePopoverViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let charlessString=textView.text.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
        let charlessInt=Int(charlessString)!
        let money:Money=Money(charlessInt)
        delegate?.retrievePrice(price: charlessInt)
        textView.text=money.formatted(withStyle: .currency)
    }
}
