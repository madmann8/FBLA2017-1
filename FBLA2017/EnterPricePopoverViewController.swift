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
    func retrievePrice(price: Int, string: String)
}


// This class is a View Controller for the enter price popover
class EnterPricePopoverViewController: UIViewController {

    @IBOutlet weak var moneyTextBox: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        moneyTextBox.delegate = self
        moneyTextBox.textAlignment = .right
        moneyTextBox.adjustsFontForContentSizeCategory = true
        moneyTextBox.font = Fonts.bold.get(size: 36)

        moneyTextBox.becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.view.layer.cornerRadius = 10
        self.view.layer.masksToBounds = true

    }

    var delegate: EnterPriceDelegate?


    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        moneyTextBox.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func okButtonPressed(_ sender: Any) {
        moneyTextBox.endEditing(true)
        let textView = self.moneyTextBox
        if let text = textView?.text {
            if !text.isEmpty {
                print(text)
                let components = text.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
                var part = components.joined(separator: "")
                part = part.trimmingCharacters(in: .whitespacesAndNewlines)
                print(part.characters.endIndex)
                var cents: String = String(part.remove(at: part.index(part.endIndex, offsetBy: -1)))
                cents += String(part.remove(at: part.index(part.endIndex, offsetBy: -1)))
                cents = String(cents.characters.reversed())
                if let dollarVal = Int(part) {
                    if let centVal = Int(cents) {
                        self.delegate?.retrievePrice(price: centVal + (dollarVal * 100), string: (textView?.text)!)
                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)

    }

}


//MARK: - TextView Delegate
extension EnterPricePopoverViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let amountString = textView.text?.currencyInputFormatting() {
            textView.text = amountString
        }
       }
}

extension String {
    
//    from http://stackoverflow.com/questions/40316335/change-textfield-dynamically-and-label-to-currency/40903216#40903216

    func currencyInputFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        var amountWithPrefix = self

        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }

}
