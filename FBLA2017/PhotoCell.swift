//
//  PhotoCell.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/8/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit

protocol PhotoCellDelegate {
    func buttonPressed(keyString: String, coverImageKeyString: String)
}

class PhotoCell: UICollectionViewCell {

    override func awakeFromNib() {
        imageView.layer.cornerRadius = 6.2
        imageView.clipsToBounds = true

    }

    var keyString: String?
    var coverImageKeyString: String?

    var delegate: PhotoCellDelegate?

    @IBAction func buttonIsPressed(_ sender: Any) {
        if let keyString = keyString, let coverImageKeyString = coverImageKeyString {
            delegate?.buttonPressed(keyString: keyString, coverImageKeyString:coverImageKeyString)
        }
    }
    @IBOutlet weak var imageView: UIImageView!

}
