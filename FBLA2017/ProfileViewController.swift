//
//  ProfileViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/15/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation
import ImagePicker
import FirebaseStorage

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var sellingContainerView: UIView!
    @IBOutlet weak var favoritesContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var geoCoder:CLGeocoder!
    var locationManager:CLLocationManager!
    var user:User?=nil

    @IBAction func imageButtonPressed(_ sender: UIButton) {
        changeProfilePicture()
    }

    @IBAction func sellingOrFavoritesToggle(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex==0{
            sellingContainerView.isHidden=false
            favoritesContainerView.isHidden=true
        }
        else {
            sellingContainerView.isHidden=true
            favoritesContainerView.isHidden=false
        }
    }
    
    override func viewDidLoad() {
        self.user=currentUser
        profileImageView.image=user?.profileImage
        nameLabel.text=user?.displayName
        cityLabel.text=user?.city
    }
    
    func setNameLabel() {
        nameLabel.text=FIRAuth.auth()?.currentUser?.displayName
        
    }
    


}





extension ProfileViewController:CLLocationManagerDelegate{
    func setCityLabel() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
               geoCode(location: location)
    }
    
    func geoCode(location : CLLocation!){
        geoCoder.cancelGeocode()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) -> Void in
            guard let placeMarks = data as [CLPlacemark]! else {
                return
            }
            let loc: CLPlacemark = placeMarks[0]
            let addressDict : [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            if addrList.count>1{
                let address:String? = addrList[1]
                self.cityLabel.text = address
            }
            else {
                if !addrList.isEmpty{
                    let address:String? = addrList[0]
                    self.cityLabel.text = address
                }
                else {
                    let address="Unknown Location"
                    self.cityLabel.text = address
                }
                
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Maps error: \(error.localizedDescription)")
        let alertController = UIAlertController(title: "Maps Error", message: error.localizedDescription, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
        
        return

    }


}

extension ProfileViewController:ImagePickerDelegate{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){}
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
    profileImageView.image=images.first
        var storageRef=FIRStorage.storage().reference()
        var data = NSData()
        data = UIImageJPEGRepresentation(profileImageView.image!, 0.5)! as NSData
        // set upload path
        let filePath = "userImages/\(FIRAuth.auth()!.currentUser!.uid)/\("userPhoto")"
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!
                //store downloadURL at database
                let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                changeRequest?.photoURL = downloadURL
                changeRequest?.commitChanges() { (error) in
                    // ...
                }
            }
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){}

    func changeProfilePicture(){
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
}
}




