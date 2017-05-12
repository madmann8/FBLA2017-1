//
//  ChatContainerViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/18/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import Pulley
import FirebaseAuth
import FirebaseDatabase

class ChatContainerViewController: UIViewController {

    var keyString: String?

    var frame: CGRect?

    var loginInUser = currentUser

    var otherUser: User?

    @IBOutlet weak var chatSwitch: UISegmentedControl!

    override func viewDidLoad() {
        chatSwitch.tintColor = UIColor.flatWatermelon
    }

    override func viewDidAppear(_ animated: Bool) {
        self.view.frame = self.frame!

    }

    var directChatView: TwoUserChatViewController?

    var globalChatView: ItemChatViewController?

    var pulley: FirstContainerViewController?

    func viewDismissed() {
        directChatView?.viewDismissed()
        globalChatView?.viewDismissed()
    }

    @IBOutlet weak var dmChatContainer: UIView!
    @IBOutlet weak var globalChat: UIView!

    @IBAction func switchChanged(_ sender: UISegmentedControl) {
        viewDismissed()
        if sender.selectedSegmentIndex == 0 {
            globalChat.isHidden = false
            dmChatContainer.isHidden = true
        } else {
            globalChat.isHidden = true
            dmChatContainer.isHidden = false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toDirectChat"{
            if let vc = segue.destination as? TwoUserChatViewController {
                vc.pulley = pulley
                self.directChatView = vc
                               let LIUID: String = (loginInUser.uid)!
                let otherUID: String = (otherUser?.uid)!
                var chatPath: String=""
                if LIUID.localizedStandardCompare(otherUID) == ComparisonResult.orderedAscending {
                    chatPath = LIUID + otherUID
                } else {
                    chatPath = otherUID + LIUID
                }
                let ref1 = FIRDatabase.database().reference().child(currentGroup).child("users").child(loginInUser.uid).child("directChats").child(chatPath)
                let ref2 = FIRDatabase.database().reference().child(currentGroup).child("users").child((otherUser?.uid)!).child("directChats").child(chatPath)
                vc.userRef1 = ref1
                vc.userRef2 = ref2
                vc.loggedInUser = loginInUser
                vc.otherUser = otherUser

                vc.channelRef = FIRDatabase.database().reference().child(currentGroup).child("chats").child("\(chatPath)")

                vc.messageRef = vc.channelRef?.child("messages")

            }
        }
        if segue.identifier=="toGlobalChat"{
            if let vc: ItemChatViewController = segue.destination as? ItemChatViewController {
                vc.pulley = pulley
                self.globalChatView = vc
                let ref = FIRDatabase.database().reference().child(currentGroup).child("users").child(currentUser.uid).child("itemChats").child(keyString!)
                vc.chatRef = ref
                vc.keyString = keyString
                vc.senderId = currentUser.uid
                vc.senderDisplayName = currentUser.displayName

            }
        }
    }
}
