//
//  PhotoCell.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/8/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit


protocol PhotoCellDelegate {
    func buttonPressed(keyString:String)
}

class PhotoCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        imageView.layer.cornerRadius = 6.2
        imageView.clipsToBounds = true

    }
    
    var keyString:String?=nil
    
    var delegate: PhotoCellDelegate?=nil
    
    @IBAction func buttonIsPressed(_ sender: Any) {
        if let keyString=keyString{
        delegate?.buttonPressed(keyString: keyString)
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
}
