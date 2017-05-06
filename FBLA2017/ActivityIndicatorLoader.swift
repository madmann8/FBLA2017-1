//
//  ActivityIndicatorLoader.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/24/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import ChameleonFramework

class ActivityIndicatorLoader {

    static func startActivityIndicator(view: UIView) -> NVActivityIndicatorView {
        let cellWidth = Int(view.frame.width / CGFloat(3))
        let cellHeight = Int(view.frame.height / CGFloat(6))
        let x = Int(view.frame.width / 2) - cellWidth / 2
        let y = Int(view.frame.height / 2) - cellWidth / 2
        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        let activityIndicator = NVActivityIndicatorView(frame: frame, type: .lineScale, color: UIColor.flatNavyBlueDark, padding: nil)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        return activityIndicator
    }
}
