//
//  MoreDetailsrViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/13/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
import ChameleonFramework

class MoreDetailsViewController: UIViewController {
    var categorey:String?=nil
    var name:String?=nil
    var about:String?=nil
    var latitudeString:String?=nil
    var longitudeString:String?=nil
    var addressString:String?=nil
    var cents:Int?=nil
    var condition:Int?=nil
    var dollarString:String?=nil
    var user:User?=nil
    var profileImageView:UIImageView?=nil


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileButton: UIButton!

    
    override func viewDidLoad() {
        setupViews()
        
    }
    


    func setupViews(){

        if
            let name=name,
//            let category = categorey,
            let about=about,
            let latitude=latitudeString,
            let longitude=longitudeString,
            let dollars:String = dollarString,
            let locationString=addressString,
            let userName=user?.displayName,
            let condition=condition{
            titleLabel.text=name
            costLabel.text="Asking Price: \(dollars)"
//            categoryLabel.text=category
            locationLabel.text=locationString
            descriptionLabel.text=about
            ratingLabel.text="Condition:\(String(describing: condition))/5"
            var nameArr = userName.components(separatedBy: " ")
            var firstName=nameArr[0]
            var lastName=""
            for i in 1..<nameArr.count{
                lastName+=nameArr[i]
            }
            firstNameLabel.text=firstName
            lastNameLabel.text=lastName
            let latDouble=Double(latitude)
            let longDouble=Double(longitude)
            let location = CLLocation(latitude: latDouble!, longitude: longDouble!)
            let regionRadius: CLLocationDistance = 1000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
            var information = MKPointAnnotation()
            information.coordinate = location.coordinate
            information.title = "Test Title!"
            information.subtitle = "Subtitle"
            
            mapView.addAnnotation(information)
            
//            if let button=profilePicButton{
//                self.profileButton=button
//            }
            
            
        }
        titleLabel.textColor=UIColor.flatWatermelonDark
        categoryLabel.textColor=UIColor.flatWatermelonDark
        ratingLabel.textColor=UIColor.flatWatermelonDark
        costLabel.textColor=UIColor.flatWatermelonDark
        descriptionLabel.textColor=UIColor.flatWatermelonDark
        locationLabel.textColor=UIColor.flatWatermelonDark
        firstNameLabel.textColor=UIColor.flatBlueDark
        lastNameLabel.textColor=UIColor.flatBlueDark
        profileImage.image = self.profileImageView?.image
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.flatGrayDark.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        


    }




    @IBAction func imageButtonPressed() {
        print("Here")
    }
    
    
//    @IBAction func profileButtonPressed(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let viewController = storyboard.instantiateViewController(withIdentifier: "OtherUserProfile") as! OtherUserProfileViewController
//        viewController.otherUser=self.user
//        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
//        UIApplication.shared.keyWindow?.rootViewController = viewController
//
//    }
//    @IBAction func profileImageButtonPressed(_ sender: UIButton) {
//
//    }

}



