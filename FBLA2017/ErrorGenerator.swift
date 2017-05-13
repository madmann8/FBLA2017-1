//
//  ErrorGenerator.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/23/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import Foundation
import UIKit

class ErrorGenerator {
    static func presentError(view: UIViewController, type: String, error: Error) {
        print("\(type) error: \(error.localizedDescription)")
        let alertController = UIAlertController(title: "\(type) Error", message: error.localizedDescription, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        view.present(alertController, animated: true, completion: nil)
        
    }
}
