//
//  ImageViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/12/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var image: UIImage?

    @IBOutlet weak var imageView: UIImageView!
    var nextItemDelegate: NextItemDelegate?

    override func viewDidLoad() {
        self.imageView.image = self.image
    }

    @IBAction func nextItemButtonPressed(_ sender: Any) {
        self.nextItemDelegate?.goToNextItem()
    }

}
