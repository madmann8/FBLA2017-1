//
//  UploadImageCollectionViewCell.swift
//  FBLA2017
//
//  Created by Luke Mann on 5/14/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import ImagePicker
import ChameleonFramework

//Class used to represent a cell in the select photo view in the upload form
public class ImageCollectionViewCell: UICollectionViewCell, ImagePickerDelegate {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    var hasLoaded = false
    var hideViews = false
    var parent: UploadItemFormViewController?=nil {
        didSet {
            if hasLoaded {
                var filledImages = 0
                if let images: [UIImage?]=parent?.images {
                    for i in 0..<images.count {
                        if images[i] != nil {
                            filledImages += 1
                        }
                    }
                }
                if (num!>filledImages + 1) {
                    hideViews = true
                    self.image.isHidden = true
                    self.button.isHidden = false
                }
            } else {
                hasLoaded = true
            }
            
        }
    }
    var num: Int?=nil {
        didSet {
            if hasLoaded {
                var filledImages = 0
                if let images: [UIImage?]=parent?.images {
                    for i in 0..<images.count {
                        if images[i] != nil {
                            filledImages += 1
                        }
                    }
                }
                if (num!>filledImages) {
                    hideViews = true
                    self.image.isHidden = true
                    self.button.isHidden = true
                }
            } else {
                hasLoaded = true
            }
            
        }
    }
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        
        var configuration = Configuration()
        configuration.backgroundColor = UIColor.flatBlue
        configuration.recordLocation = false
        configuration.showsImageCountLabel = false
        let imagePickerController = ImagePickerController(configuration: configuration)
        imagePickerController.delegate = self
        imagePickerController.imageLimit=1
        
        
        parent?.present(imagePickerController, animated: true, completion: nil)
        
    }
    override public func awakeFromNib() {
        self.backgroundColor = UIColor.flatGray
        self.layer.cornerRadius = 10
        let frame = self.frame
        self.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.width)
        if hideViews {
            self.image.isHidden = false
            self.button.isHidden = false
        }
    }
    
    //MARK: - ImagePicker Delegate
    public func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if num! <  (parent?.images.count)!{
        parent?.images[num!]=images[0]
        self.image.image = images[0]
        if num!<4 {
            if let cell = parent?.imageCells[num!+1] {
                cell.image.isHidden = false
                cell.button.isHidden = false
            }
            
            }}
        imagePicker.dismiss(animated: true, completion: nil)
    }
    public func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    public func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    }
    
}

