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
import ChameleonFramework
import Presentr
import CoreLocation



class UploadItemFormViewController:UIViewController{
    
    var images:[UIImage]? = nil
    var cents:Int?=nil
    var descrption:String?=nil
    var condition:Int?=nil
    var location:CLLocation?=nil
    
    
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
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    //
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        //
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("Here")
        imagePicker.dismiss(animated: true, completion: nil)
        self.images=images
        //
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        
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
        descrption=textView.text
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
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "SelectLocationViewController") as! SelectLocationViewController
        vc.delgate=self
        present(vc, animated: true, completion: nil)
        
    }
    

    
    
    func recieveLocation(location: CLLocation) {
        print("HERE2")
        let geoCoder=CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) -> Void in
            guard let placeMarks = data as [CLPlacemark]! else {
                return
            }
            let loc: CLPlacemark = placeMarks[0]
            let addressDict : [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            if addrList.count>1{
                let address:String? = addrList[1]
                print("Addressss: \(address)")
                self.locationButton.titleLabel?.text = "\(address)"
            }
            else {
                if !addrList.isEmpty{
                    let address:String? = addrList[0]
                    self.locationButton.titleLabel?.text = address
                }
                else {
                    let address="Unknown Location"
                    self.locationButton.titleLabel?.text = address
                }
                
            }
        })

        self.location=location
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

