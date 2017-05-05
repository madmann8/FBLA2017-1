//
//  CachedData.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/11/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import Firebase
import NVActivityIndicatorView

class CachedData {

    func loadCoverImages(view: UIView) {
        let cellWidth = Int(view.frame.width / CGFloat(4))
        let cellHeight = Int(view.frame.height / CGFloat(8))
        let x = Int(view.frame.width / 2) - cellWidth / 2
        let y = Int(view.frame.height / 2) - cellWidth / 2
        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        let activityIndicator = NVActivityIndicatorView(frame: frame, type: .pacman, color: UIColor.red, padding: nil)
        activityIndicator.startAnimating()

        var ref = FIRDatabase.database().reference().child("coverImagePaths")
        ref.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snapshot in snapshots {
                    if let path = snapshot.value as? String {
                        print("String: \(path)")
                    }
                }
            }
            activityIndicator.stopAnimating()

        })
    }
}
