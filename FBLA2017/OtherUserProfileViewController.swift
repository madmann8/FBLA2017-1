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
import Instructions

class OtherUserProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var sellingContainerView: UIView!
    @IBOutlet weak var favoritesContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var exitButtton: UIButton!

    @IBOutlet weak var imageSwitch: UISegmentedControl!

    var geoCoder: CLGeocoder!
    var locationManager: CLLocationManager!
    var loginInUser: User?
    var otherUser: User?
    var loadOtherChat = false
    var hasLoaded = false

    let walkthroughController = CoachMarksController()

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
        walkthroughController.dataSource = self

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
        if !UserDefaults.standard.bool(forKey: "OtherUserWalkthroughHasLoaded") {
            self.walkthroughController.startOn(self)
            UserDefaults.standard.set(true, forKey: "OtherUserWalkthroughHasLoaded")
        }

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
            vc.channelRef = FIRDatabase.database().reference().child(currentGroup).child("chats").child("\(chatPath)")
            vc.loggedInUser = loginInUser
                vc.otherUser = otherUser
            vc.messageRef = vc.channelRef?.child("messages")
                    vc.hideButton = false

            }
        }

        if segue.identifier=="toSelling"{
             let vc = segue.destination as! SellingCollectionViewController
            vc.frameToLoad = self.favoritesContainerView.frame
            vc.user = self.otherUser

        }
        if segue.identifier=="toFavorites"{
             let vc = segue.destination as! FavoritesCollectionViewController
            vc.frameToLoad = self.sellingContainerView.frame
            vc.user = self.otherUser

        }
    }

}

extension OtherUserProfileViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: self.imageSwitch)
    }
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let view = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)

        view.bodyView.hintLabel.text = "Use this to switch between viewing items the user has favorited and items the user is selling"
        view.bodyView.hintLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)!
        view.bodyView.nextLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16)!
        //        UIFont(name: "AvenirNext-Regular", size: 15)!
        view.bodyView.nextLabel.text = "Ok!"

        return (bodyView: view.bodyView, arrowView: view.arrowView)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.walkthroughController.stop(immediately: true)
    }
}
