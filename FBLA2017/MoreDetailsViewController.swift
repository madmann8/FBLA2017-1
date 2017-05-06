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
import Device

class MoreDetailsViewController: UIViewController {

    var profileImageView: UIImageView?
    var item:Item?=nil

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
        super.viewDidLoad()
        setupViews()

    }

    func setupViews() {


            titleLabel.text = item?.name
        if let dollarString = item!.dollarString{
                  costLabel.text="Asking Price: \(dollarString)"
        }
        else {
            costLabel.text="Asking Price: \(item?.dollarString)"

        }
        if let categorey = item!.categorey{
            categoryLabel.text = categorey
        }
        else {
            categoryLabel.text = item?.categorey
            
        }
        if let condition = item!.condition{
            ratingLabel.text="Condition:\(String(describing: condition))/5"
        }
        else {
            ratingLabel.text="Condition:\(String(describing: item?.condition))/5"
            
        }
        
        if let addressString = item!.addressString{
            locationLabel.text = addressString
        }
        else {
            locationLabel.text = item!.addressString
            
        }
        if let about = item!.about{
            descriptionLabel.text = about
        }
        else {
            descriptionLabel.text = item?.about
            
        }
                       var nameArr = item?.user?.displayName.components(separatedBy: " ")
            var firstName = nameArr?[0]
            var lastName=""
            for i in 1 ..< nameArr!.count {
                lastName += (nameArr?[i])!
            }
            firstNameLabel.text = firstName
            lastNameLabel.text = lastName
            let latDouble = Double((item?.latitudeString)!)
            let longDouble = Double((item?.longitudeString
                )!)
            let location = CLLocation(latitude: latDouble!, longitude: longDouble!)
            let regionRadius: CLLocationDistance = 1_000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
            var information = MKPointAnnotation()
            information.coordinate = location.coordinate
            information.title = item?.name
            information.subtitle = "Seller Location"

            mapView.addAnnotation(information)

            //            if let button=profilePicButton{
            //                self.profileButton=button
            //            }
        titleLabel.textColor = UIColor.flatWatermelonDark
        categoryLabel.textColor = UIColor.flatWatermelonDark
        ratingLabel.textColor = UIColor.flatWatermelonDark
        costLabel.textColor = UIColor.flatWatermelonDark
        descriptionLabel.textColor = UIColor.flatWatermelonDark
        locationLabel.textColor = UIColor.flatWatermelonDark
        firstNameLabel.textColor = UIColor.flatBlueDark
        lastNameLabel.textColor = UIColor.flatBlueDark
        profileImage.image = self.profileImageView?.image
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.flatGrayDark.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        let frame = mapView.frame

        switch Device.size() {
        case .screen4_7Inch:
            mapView.frame = CGRect(x: 20, y: frame.minY, width: self.view.frame.width - 50, height: 280)
        case .screen5_5Inch:
            mapView.frame = CGRect(x: 20, y: frame.minY, width: self.view.frame.width - 50, height: 330)
        default:
            mapView.frame = CGRect(x: 20, y: frame.minY, width: self.view.frame.width - 20, height: 280)

        }

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
