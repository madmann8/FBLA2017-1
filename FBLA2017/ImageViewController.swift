//
//  ImageViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/12/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var image:UIImage?=nil

    @IBOutlet weak var imageView: UIImageView!
 
    override func viewDidLoad() {
        self.imageView.image=self.image
    }
    
    

}