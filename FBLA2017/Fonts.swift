//
//  Fonts.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/23/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import Foundation
import UIKit

enum Fonts: String {
    case regular = "Avenir"
    case bold = "AvenirNext-DemiBold"
    case medium = "AvenirNext-Medium"
    func get(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
