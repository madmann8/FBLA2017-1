//
//  SBMaker.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/12/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import Foundation
import UIKit


class SBMaker {
    static func newVC(vc: String)-> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: vc)
    }
}
