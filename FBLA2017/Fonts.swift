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
    case Regular = "Avenir"
    case HeavyItalic = "AvenirNext-HeavyItalic"
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
