//
//  UploadItemFormViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/8/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//


//On the next episode: We'll shoot everything throught the interwebs into Google's servers

import Foundation
import UIKit
import ImagePicker
import ChameleonFramework
import Presentr
import CoreLocation
import DropDown
import GSMessages
import Firebase





class UploadItemFormViewController:UIViewController{
    let pickerView:DropDown=DropDown()
    var hasSetup=false

    
    let categories = ["test1", "test2", "test3", "test4", "test5"]
    
    var name:String?=nil
    var images:[UIImage]? = nil
    var cents:Int?=nil
    var about:String?=nil
    var condition:Int?=nil
    var locationString:String?=nil
    var locationLatitude:String?=nil
    var locationLongitude:String?=nil

    var category:String?=nil
    
    var ref: FIRDatabaseReference!

    
    
    var imagePickerController = ImagePickerController()
    var hasSetupImagePicker=false
    
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var conditionSlider: UISlider!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var conditionLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        descriptionTextView.delegate=self
        titleTextField.delegate=self
        ref = FIRDatabase.database().reference()

    }
    
    
}

//IMAGE STUFF
extension UploadItemFormViewController:ImagePickerDelegate{
    
    
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        if !hasSetupImagePicker{
            var configuration = Configuration()
            configuration.backgroundColor=UIColor.flatBlue
            configuration.recordLocation = false
            //            configuration.
            self.imagePickerController = ImagePickerController(configuration: configuration)
            self.imagePickerController.delegate = self
            hasSetupImagePicker=true
        }
        present(imagePickerController, animated: true, completion: nil)
    }
    //
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        //
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        self.images=images
        //
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
}


//Title Stuff
extension UploadItemFormViewController:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.name=textField.text
    }
}



//Price Stuff

extension UploadItemFormViewController:EnterPriceDelegate{
    @IBAction func priceButtonPressed(_ sender: UIButton) {
        let screenSize: CGRect = UIScreen.main.bounds
        let width = ModalSize.fluid(percentage: 0.7)
        let height = ModalSize.fluid(percentage: 0.3)
        let center = ModalCenterPosition.center
        
        let presentationType = PresentationType.custom(width: width, height: height, center: center
        )
        let dynamicSizePresenter = Presentr(presentationType: presentationType)
        let dynamicVC = storyboard!.instantiateViewController(withIdentifier: "DynamicViewController") as! EnterPricePopoverViewController
        //        rdynamicSizePresenter.presentationType = .popup
        dynamicVC.delegate=self
        customPresentViewController(dynamicSizePresenter, viewController: dynamicVC, animated: true, completion: nil)
        
    }
    
    func retrievePrice(price: Int) {
        self.cents=price
    }
    
    
}




//Description Stuff
extension UploadItemFormViewController:UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        about=textView.text
    }
}


//Condition Stuff


extension UploadItemFormViewController{
    @IBAction func conditionSliderDidChange(_ sender: UISlider) {
        let step:Float=1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        conditionLabel.text=String(Int(roundedValue))
        self.condition=Int(roundedValue)
    }
    
}

//Location Stuff
extension UploadItemFormViewController:SelectLocationProtocol{
    func recieveLocation(latitude: String, longitude: String, addressString: String) {
        self.locationButton.setTitle(addressString, for: .normal)
        self.locationLatitude=latitude
        self.locationLongitude=longitude
        self.locationString=addressString
    }

    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "SelectLocationViewController") as! SelectLocationViewController
        vc.delgate=self
        present(vc, animated: true, completion: nil)
        
    }

}





// Category Stuff
extension UploadItemFormViewController {

    @IBAction func categoryButtonPressed(_ sender: UIButton) {
        print("HERE")
        if (!hasSetup){
            self.pickerView.anchorView = self.categoryButton
            self.pickerView.dataSource = ["Electronics", "Cars and Motors", "Sports and Games", "Home and Garden", "Fashion and Accessories", "Movies, Books and Music", "Other"]
            self.pickerView.selectionAction = { [unowned self] (index: Int, item: String) in
                self.category=item
                self.categoryButton.setTitle(item, for: .normal)
            }
            hasSetup=true
        }
        pickerView.show()
        
    }
}




//Upload Stuff
extension UploadItemFormViewController{
    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        if (images==nil || name==nil || cents==nil || about==nil || condition==nil || locationString==nil || category==nil) {
            if images==nil {
                self.showMessage("Missing images", type: .error)
            }
            if name==nil{
                self.showMessage("Missing name", type: .error)
            }
            if cents==nil{
                self.showMessage("Missing cents", type: .error)
            }
            if about==nil{
                self.showMessage("Missing about", type: .error)
            }
            if condition==nil{
                self.showMessage("Missing condition", type: .error)
            }
            if locationString==nil{
                self.showMessage("Missing location", type: .error)
            }
            if category==nil{
                self.showMessage("Missing category", type: .error)
            }
        }
        let itemRef=self.ref.child("items").childByAutoId()
    
        itemRef.child("title").setValue(self.name)
        itemRef.child("cents").setValue(self.cents)
        itemRef.child("about").setValue(self.about)
        itemRef.child("condition").setValue(self.condition)
        itemRef.child("locationString").setValue(self.locationString)
        itemRef.child("locationLatitude").setValue(self.locationLatitude)
        itemRef.child("locationLongitude").setValue(self.locationLongitude)
        itemRef.child("category").setValue(category)
        
        let autoID=itemRef.key

        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("itemImages")
        let uniqueItemImageRef = storageRef.child("itemImages/\(key).jpg")


        

    }
}








extension UIImageView
{
    func roundCornersForAspectFit(radius: CGFloat)
    {
        if let image = self.image {
            
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

