//
//  UploadItemFormViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/8/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//


//On the next episode: We'll make the image buttons into one and connect ImagePicker to the rest of the app


import Foundation
import UIKit
import ImagePicker

class UploadItemFormViewController:UIViewController{
    
    var images:[UIImage] = []
    let imagePickerController = ImagePickerController()
    
    
    @IBOutlet weak var addPhoto1: UIImageView!
    @IBOutlet weak var addPhoto2: UIImageView!
    @IBOutlet weak var addPhoto3: UIImageView!
    @IBOutlet weak var addButton1: UIButton!
    @IBOutlet weak var addButton2: UIButton!
    @IBOutlet weak var addButton3: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var conditionSlider: UISlider!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    
    override func viewDidLoad() {
        addPhoto1.roundCornersForAspectFit(radius: 6)
        addPhoto2.roundCornersForAspectFit(radius: 6)
        addPhoto3.roundCornersForAspectFit(radius: 6)
    }
    

}

//IMAGE STUFF
extension UploadItemFormViewController:ImagePickerDelegate{

    @IBAction func addButton1Pressed(_ sender: UIButton) {
        print(sender.titleLabel)
        self.imagePickerController.delegate = self
        self.present(self.imagePickerController, animated: true, completion: nil)

    }
    
    @IBAction func addButton2Pressed(_ sender: UIButton) {
    }
    
    @IBAction func addButton3Pressed(_ sender: UIButton) {
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        //
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        //
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
                imagePicker.dismiss(animated: true, completion: nil)

    }
}






extension UIImageView
{
    func roundCornersForAspectFit(radius: CGFloat)
    {
        if let image = self.image {
            
            //calculate drawingRect
            let boundsScale = self.bounds.size.width / self.bounds.size.height
            let imageScale = image.size.width / image.size.height
            
            var drawingRect : CGRect = self.bounds
            
            if boundsScale > imageScale {
                drawingRect.size.width =  drawingRect.size.height * imageScale
                drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
            }else{
                drawingRect.size.height = drawingRect.size.width / imageScale
                drawingRect.origin.y = (self.bounds.size.height - drawingRect.size.height) / 2
            }
            let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}

