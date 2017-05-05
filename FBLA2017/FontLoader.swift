//
//  FontLoader.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/9/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import Foundation
import UIKit

public extension UIFont {

    class func loadAllFonts(bundleIdentifierString: String) {
        registerFontWithFilenameString(filenameString: "icon-font.ttf", bundleIdentifierString: bundleIdentifierString)
        // Add more font files here as required
    }

    static func registerFontWithFilenameString(filenameString: String, bundleIdentifierString: String) {
        if let frameworkBundle = Bundle(identifier: bundleIdentifierString) {
            let pathForResourceString = frameworkBundle.path(forResource: filenameString, ofType: nil)
            let fontData = NSData(contentsOfFile: pathForResourceString!)
            let dataProvider = CGDataProvider(data: fontData!)
            let fontRef = CGFont(dataProvider!)
            var errorRef: Unmanaged<CFError>? = nil

            if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
                print("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
            }
        } else {
            print("Failed to register font - bundle identifier invalid.")
        }
    }
}
