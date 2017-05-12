//
//  TwoUserChatViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/16/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import ChameleonFramework
import FirebaseDatabase
import FirebaseStorage
import JSQMessagesViewController
import Photos
import ImagePicker
import FirebaseAuth
import Pulley

class TwoUserChatViewController: UIViewController {

    @IBOutlet weak var exitButton: UIButton!

    var frame: CGRect?

    lazy var storageRef: FIRStorageReference = FIRStorage.storage().reference().child(currentGroup)

    let imageURLNotSetKey = "NOTSET"

    var userRef1: FIRDatabaseReference?
    var userRef2: FIRDatabaseReference?

    var loggedInUser: User?
    var otherUser: User?

    var hideButton: Bool = true

    var chatVC: ActualTwoUserChatViewController?

    var pulley: FirstContainerViewController?

    func viewDismissed() {
        chatVC?.viewDismissed()
    }

    var messageRef: FIRDatabaseReference?
    var channelRef: FIRDatabaseReference?
    override func viewDidLoad() {
        if hideButton {
            exitButton.isHidden = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toContainedChat"{
            if let vc = segue.destination as? ActualTwoUserChatViewController {
                self.chatVC = vc
                vc.pulley = pulley
                vc.senderId = currentUser.uid
                vc.senderDisplayName = currentUser.displayName
                let LIUID: String = (loggedInUser?.uid)!
                let otherUID: String = (otherUser?.uid)!
                var chatPath: String=""
                if LIUID.localizedStandardCompare(otherUID) == ComparisonResult.orderedAscending {
                    chatPath = LIUID + otherUID
                } else {
                    chatPath = otherUID + LIUID
                }
                vc.channelRef = FIRDatabase.database().reference().child(currentGroup).child("chats").child("\(chatPath)")
                vc.userRef1 = userRef1
                vc.userRef2 = userRef2
                vc.loggedInUser = loggedInUser
                vc.otherUser = otherUser

                vc.messageRef = vc.channelRef?.child("messages")

            }
        }
 }

}
