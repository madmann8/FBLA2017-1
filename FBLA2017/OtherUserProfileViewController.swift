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
    var geoCoder:CLGeocoder!
    var locationManager:CLLocationManager!
    var loginInUser:User?=nil
    var otherUser:User?=nil
    
    
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
        self.loginInUser=currentUser
        profileImageView.image=otherUser?.profileImage
        nameLabel.text=otherUser?.displayName
        cityLabel.text=otherUser?.city
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toChat"{
            let vc=segue.destination as! TwoUserChatViewController
            vc.senderId=currentUser.uid
            vc.senderDisplayName=vc.senderId
                     let LIUID:String=(loginInUser?.uid)!
            let otherUID:String=(otherUser?.uid)!
            var chatPath:String=""
            if LIUID.localizedStandardCompare(otherUID)==ComparisonResult.orderedAscending{
                chatPath=LIUID+otherUID
            }
            else {
                chatPath=otherUID+LIUID
            }
            vc.channelRef=FIRDatabase.database().reference().child("chats").child("\(chatPath)")
            
            vc.messageRef=vc.channelRef?.child("messages")
            
            

        }
    }
    
}








