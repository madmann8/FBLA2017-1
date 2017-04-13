//
//  ImageAndButtonsViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/13/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit

class ImageAndButtonsViewController: UIViewController {
    
    var image:UIImage?=nil

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        self.imageView.image=self.image
    }

    @IBAction func exitButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
