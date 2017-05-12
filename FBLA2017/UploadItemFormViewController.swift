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
import NVActivityIndicatorView
import Firebase
import FirebaseStorage
import PopoverPicker

protocol UploadFinishedDelegate {
    func reload()
}

class UploadItemFormViewController: UIViewController {
//    let pickerView:DropDown=DropDown()
    var hasSetup = false

    var name: String?
    var images=[UIImage?](repeatElement(nil, count: 5))
    var cents: Int?
    var about: String?
    var condition: Int?
    var locationString: String?
    var locationLatitude: String?
    var locationLongitude: String?

    var category: String?

    var ref: FIRDatabaseReference!

    var delegate: UploadFinishedDelegate?

    var categories=[String]()

    var imagePickerController = ImagePickerController()
    var hasSetupImagePicker = false
    var imageCells=[ImageCollectionViewCell]()

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var conditionSlider: UISlider!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var uploadButton: UIButton!

    var selectedCell: Int = 0

    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        descriptionTextView.delegate = self
        descriptionTextView.contentInset = UIEdgeInsets(top: -4, left: -3, bottom: 0, right: 0)
        titleTextField.delegate = self
        ref = FIRDatabase.database().reference().child(currentGroup)
        selectedCell = 0
        titleTextField.textColor = UIColor.lightGray
        descriptionTextView.textColor = UIColor.lightGray
        priceButton.titleLabel?.minimumScaleFactor = 0.5
        priceButton.titleLabel?.numberOfLines = 1
        priceButton.titleLabel?.adjustsFontSizeToFitWidth = true
        priceButton.backgroundColor = .clear
        priceButton.layer.cornerRadius = 5
        priceButton.layer.borderWidth = 0.75
        priceButton.layer.borderColor =
            UIColor.lightGray.cgColor
        categoryButton.setTitleColor(UIColor.lightGray, for: .normal)
        let height = uploadButton.frame.height
        uploadButton.layer.cornerRadius = height / 2

        }

}

//IMAGE STUFF
extension UploadItemFormViewController:ImagePickerDelegate {

    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        if !hasSetupImagePicker {
            var configuration = Configuration()
            configuration.backgroundColor = UIColor.flatBlue
            configuration.recordLocation = false
            //            configuration.
            self.imagePickerController = ImagePickerController(configuration: configuration)
            self.imagePickerController.delegate = self
            self.imagePickerController.imageLimit = 1
            hasSetupImagePicker = true
        }
        present(imagePickerController, animated: true, completion: nil)
    }
    //

    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        //
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        self.images = images
        //
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)

    }
}

//Title Stuff
extension UploadItemFormViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = UIColor.black
        }

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.name = textField.text
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//Description Stuff
extension UploadItemFormViewController:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        about = textView.text
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}

//Price Stuff

extension UploadItemFormViewController:EnterPriceDelegate {
    @IBAction func priceButtonPressed(_ sender: UIButton) {
        descriptionTextView.resignFirstResponder()
        titleTextField.resignFirstResponder()
        let width = ModalSize.fluid(percentage: 0.7)
        let height = ModalSize.fluid(percentage: 0.3)
        let center = ModalCenterPosition.center

        let presentationType = PresentationType.custom(width: width, height: height, center: center
        )
        let dynamicSizePresenter = Presentr(presentationType: presentationType)
        let dynamicVC = storyboard!.instantiateViewController(withIdentifier: "DynamicViewController") as! EnterPricePopoverViewController
        dynamicVC.delegate = self
        customPresentViewController(dynamicSizePresenter, viewController: dynamicVC, animated: true, completion: nil)

    }

    func retrievePrice(price: Int, string: String) {
        self.cents = price
        priceButton.setTitle(string, for: .normal)
        priceButton.setTitleColor(UIColor.black, for: .normal)
        priceButton.layer.borderColor = UIColor.black.cgColor
    }

}

//Condition Stuff

extension UploadItemFormViewController {
    @IBAction func conditionSliderDidChange(_ sender: UISlider) {
        let step: Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        conditionLabel.text = String(Int(roundedValue))
        self.condition = Int(roundedValue)
    }

}

//Location Stuff
extension UploadItemFormViewController:SelectLocationProtocol {
    func recieveLocation(latitude: String, longitude: String, addressString: String) {
        self.locationButton.setTitle(addressString, for: .normal)
        self.locationButton.setTitleColor(UIColor.black, for: .normal)
        self.locationLatitude = latitude
        self.locationLongitude = longitude
        self.locationString = addressString

    }

    @IBAction func locationButtonPressed(_ sender: UIButton) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "SelectLocationViewController") as! SelectLocationViewController
        vc.delgate = self
        present(vc, animated: true, completion: nil)

    }

}

// Category Stuff
extension UploadItemFormViewController {

    @IBAction func categoryButtonPressed(_ sender: UIButton) {
        let popoverView = PickerDialog.getPicker()
        let pickerData = [
            ["value": "School Supplies", "display": "School Supplies"],
            ["value": "Electronics", "display": "Electronics"],
            ["value": "Home and Garden", "display": "Home and Garden"],
            ["value": "Clothing", "display": "Clothing"],
            ["value": "Sports and Games", "display": "Sports and Games"],
            ["value": "Other", "display": "Other"],

        ]
        popoverView.show("Select Category", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", options: pickerData, selected:  "School Supplies") {
            (value) -> Void in

            self.categoryButton.setTitle(value, for: .normal)
            self.categoryButton.setTitleColor(UIColor.black, for: .normal)
            self.category = value
        }
    }
}

//Upload Stuff
extension UploadItemFormViewController {
    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        let cellWidth = Int(self.view.frame.width / CGFloat(4))
        let cellHeight = Int(self.view.frame.height / CGFloat(8))
        let x = Int(self.view.frame.width / 2) - cellWidth / 2
        let y = Int(self.view.frame.height / 2) - cellWidth / 2
        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)

        var missingData = false
        if (images[0]==nil || name == nil || cents == nil || about == nil || condition == nil || locationString == nil || category == nil) {
            missingData = true
            if images[0]==nil {
                self.showMessage("Missing images", type: .error)
            } else if name == nil {
                self.showMessage("Missing name", type: .error)
            } else if cents == nil {
                self.showMessage("Missing price", type: .error)
            } else if about == nil {
                self.showMessage("Missing about", type: .error)
            } else if condition == nil {
                self.showMessage("Missing condition", type: .error)
            } else if locationString == nil {
                self.showMessage("Missing location", type: .error)
            } else if category == nil {
                self.showMessage("Missing category", type: .error)
            }
        }

                if !missingData {
        let itemRef = self.ref.child("items").childByAutoId()
                    let activityIndicator = ActivityIndicatorLoader.startActivityIndicator(view: self.view)

        itemRef.child("title").setValue(self.name)
        itemRef.child("cents").setValue((self.cents)!)
        itemRef.child("about").setValue(self.about)
        itemRef.child("condition").setValue(self.condition)
        itemRef.child("locationString").setValue(self.locationString)
        itemRef.child("locationLatitude").setValue(self.locationLatitude)
        itemRef.child("locationLongitude").setValue(self.locationLongitude)
        itemRef.child("category").setValue(category)
        itemRef.child("userID").setValue(FIRAuth.auth()?.currentUser?.uid)

        let autoID = itemRef.key

        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let uniqueItemImageRef = storageRef.child("itemImages/\(autoID)")
        var i = 0

        var mainImagePaths=[String]()
        let trimedImages = images.filter { $0 != nil }
        let coverImageRef = ref.child("coverImagePaths")
        let coverImage = trimedImages[0]?.jpeg(.lowest)
        let imageNumberRef = uniqueItemImageRef.child("cover.jpeg")
        _ = imageNumberRef.put(coverImage!)
        for image in trimedImages {
            let imageNumberRef = uniqueItemImageRef.child("\(i).jpeg")
            mainImagePaths.append("\(imageNumberRef)")
            i += 1
            let imageData = image?.jpeg(.medium)
            _ = imageNumberRef.put(imageData!, metadata: nil) { (metadata, _) in
                guard let metadata = metadata else {

                    return
                }
                if i == trimedImages.count {
                    activityIndicator.stopAnimating()
                    self.delegate?.reload()
                }
            }

        }
        var e = 0
        for s in mainImagePaths {
            itemRef.child("imagePaths").child("\(e)").setValue(s)
            e += 1
        }
        coverImageRef.child(autoID).setValue("\(imageNumberRef)")
        let userRef = ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
        itemRef.child("coverImage").setValue("\(imageNumberRef)")
        userRef.child("coverImages").child(autoID).setValue("\(imageNumberRef)")

    }

    //UNcomment to prevent missing information uploads
        }
}

extension UploadItemFormViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ImageCollectionViewCell
        cell.image.image=#imageLiteral(resourceName: "AddPhoto")
        cell.parent = self
        cell.num = self.selectedCell
        selectedCell += 1
        self.imageCells.append(cell)
        return cell

    }
}

class ImageCollectionViewCell: UICollectionViewCell, ImagePickerDelegate {
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
                    if let image = images[i] {
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
                        if let image = images[i] {
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
            //            configuration.
           let imagePickerController = ImagePickerController(configuration: configuration)
            imagePickerController.delegate = self

        parent?.present(imagePickerController, animated: true, completion: nil)

}
    override func awakeFromNib() {
        self.backgroundColor = UIColor.flatGray
        self.layer.cornerRadius = 10
        let frame = self.frame
        self.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.width)
        if hideViews {
            self.image.isHidden = false
            self.button.isHidden = false
        }
            }

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        parent?.images[num!]=images[0]
        self.image.image = images[0]
        if num!<4 {
        if let cell = parent?.imageCells[num!+1] {
            cell.image.isHidden = false
            cell.button.isHidden = false
        }

        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        //
    }

}

extension UIImageView {
    func roundCornersForAspectFit(radius: CGFloat) {
        if let image = self.image {

            let boundsScale = self.bounds.size.width / self.bounds.size.height
            let imageScale = image.size.width / image.size.height

            var drawingRect: CGRect = self.bounds

            if boundsScale > imageScale {
                drawingRect.size.width = drawingRect.size.height * imageScale
                drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
            } else {
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

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.7
        case high = 0.75
        case highest = 1
    }

     var png: Data? { return UIImagePNGRepresentation(self) }

     func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}
