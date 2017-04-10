//
//  EnterPricePopoverViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/9/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import Format

protocol EnterPriceDelegate {
    func retrievePrice(price: Int)
}

class EnterPricePopoverViewController: UIViewController {
    
    @IBOutlet weak var moneyTextBox: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.blue
        moneyTextBox.delegate=self
        moneyTextBox.textAlignment = .right
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
        if let amountString = textView.text?.currencyInputFormatting() {
            textView.text = amountString
        }
//        let exludedSymbols=[",","$","."]
        let charSet=CharacterSet(charactersIn: "$")
        let result=textView.text.trimmingCharacters(in: charSet)
        print(result)
//        if let text=textView.text{
//            for  i in 0...text.characters.count{
//                let str = Array(text.characters).flatMap { $0 as? String }
//                if exludedSymbols.contains(str[0]){
//                   textView.text.characters.remove(at: i)
//                }
//        }
//        }
    }
}


extension String {
    
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    
}

