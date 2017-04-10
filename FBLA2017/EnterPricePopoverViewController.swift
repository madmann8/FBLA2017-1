//
//  EnterPricePopoverViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/9/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//




import UIKit




protocol EnterPriceDelegate {
    func retrievePrice(price: Int)
}

class EnterPricePopoverViewController: UIViewController {

    var amount: Int { return moneyTextBox.string.digits.integer }

    @IBOutlet weak var moneyTextBox: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.blue
        moneyTextBox.delegate=self
        moneyTextBox.textAlignment = .right
        moneyTextBox.keyboardType = .numberPad
        moneyTextBox.text=Formatter.decimal.string(from: amount as NSNumber)
        
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
        textView.text=Formatter.decimal.string(from: amount as NSNumber)
    }
}



extension UITextView {
    var string: String { return text ?? "" }
}

extension NumberFormatter {
    convenience init(numberStyle: NumberFormatter.Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}
struct Formatter {
    static let decimal = NumberFormatter(numberStyle: .decimal)
}


extension String {
    private static var digitsPattern = UnicodeScalar("0")..."9"
    var digits: String {
        return unicodeScalars.filter { String.digitsPattern ~= $0 }.string
    }
    var integer: Int { return Int(self) ?? 0 }
}

extension Sequence where Iterator.Element == UnicodeScalar {
    var string: String { return String(String.UnicodeScalarView(self)) }
}
