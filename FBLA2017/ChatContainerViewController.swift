//
//  ChatContainerViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/18/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatContainerViewController: UIViewController {
    
    var keyString:String?=nil
    
    var frame:CGRect?=nil
    
    var loginInUser=currentUser
    
    var otherUser:User?=nil
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.frame=self.frame!

    }
    
    @IBOutlet weak var dmChatContainer: UIView!
    @IBOutlet weak var globalChat: UIView!
    
    @IBAction func switchChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex==0{
            globalChat.isHidden=false
            dmChatContainer.isHidden=true
        }
        else {
            globalChat.isHidden=true
            dmChatContainer.isHidden=false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toDirectChat"{
            if let vc=segue.destination as? TwoUserChatViewController {
                vc.senderId=currentUser.uid
                vc.senderDisplayName=vc.senderId
                let LIUID:String=(loginInUser.uid)!
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
        if segue.identifier=="toGlobalChat"{
            if let vc:ItemChatViewController=segue.destination as! ItemChatViewController{
                vc.keyString=keyString
                vc.senderId=FIRAuth.auth()?.currentUser?.uid
                vc.senderDisplayName=vc.senderId

            }
        }
    }
}
