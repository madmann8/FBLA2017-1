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
import FirebaseDatabase

class OtherUserProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var sellingContainerView: UIView!
    @IBOutlet weak var favoritesContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var exitButtton: UIButton!
    var geoCoder: CLGeocoder!
    var locationManager: CLLocationManager!
    var loginInUser: User?
    var otherUser: User?
    var loadOtherChat = false
    var hasLoaded = false

    @IBAction func sellingOrFavoritesToggle(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sellingContainerView.isHidden = false
            favoritesContainerView.isHidden = true
        } else {
            sellingContainerView.isHidden = true
            favoritesContainerView.isHidden = false
        }
    }

    override func viewDidLoad() {
        self.loginInUser = currentUser
        profileImageView.image = otherUser?.profileImage
        nameLabel.text = otherUser?.displayName
        cityLabel.text = otherUser?.city

        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.flatGrayDark.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        cityLabel.textColor = UIColor.flatNavyBlue
        nameLabel.textColor = UIColor.flatNavyBlue

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if loadOtherChat && !hasLoaded {
            self.performSegue(withIdentifier: "toChat", sender: nil)
            hasLoaded = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toChat"{
            if let vc = segue.destination as? TwoUserChatViewController {

                let LIUID: String = (loginInUser?.uid)!
            let otherUID: String = (otherUser?.uid)!
            var chatPath: String=""
            if LIUID.localizedStandardCompare(otherUID) == ComparisonResult.orderedAscending {
                chatPath = LIUID + otherUID
            } else {
                chatPath = otherUID + LIUID
            }
            vc.channelRef = FIRDatabase.database().reference().child("chats").child("\(chatPath)")
            vc.loggedInUser = loginInUser
                vc.otherUser = otherUser
            vc.messageRef = vc.channelRef?.child("messages")
                    vc.hideButton = false

            }
        }

        if segue.identifier=="toSelling"{
             let vc = segue.destination as! SellingCollectionViewController
                vc.user = self.otherUser

        }
        if segue.identifier=="toFavorites"{
             let vc = segue.destination as! FavoritesCollectionViewController
                vc.user = self.otherUser

        }
    }

}
