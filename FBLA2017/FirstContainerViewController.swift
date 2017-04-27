//
//  SlideUpContainerViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/13/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import Pulley
import FirebaseAuth




class FirstContainerViewController:PulleyViewController {

    var images:[UIImage]?=nil
    var categorey:String?=nil
    var name:String?=nil
    var about:String?=nil
    var latitudeString:String?=nil
    var longitudeString:String?=nil
    var addressString:String?=nil
    var cents:Int?=nil
    var condition:Int?=nil
    var keyString:String?=nil
    var coverImagePath:String?=nil
    var userID:String?=nil
    var user:User?=nil
    var vcToDismiss:FirstContainerViewController?=nil
    var userDelegate:UserDelegate?=nil
    var tempUserImage:UIImage?=nil
 
    
    
    var nextItemDelegate:NextItemDelegate?=nil
    var dismissDelegate:DismissDelgate?=nil
 
    @IBOutlet weak var primaryView: UIView!
    @IBOutlet weak var secondaryView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate=self
        setNeedsSupportedDrawerPositionsUpdate()
//        user.setupUser(id: userID!, isLoggedIn: false)
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.primaryContentContainerView=self.primaryView
        self.drawerContentContainerView=self.secondaryView
        if segue.identifier=="toSecondContainer"{
            if let middle:InfoContainerViewController=segue.destination as? InfoContainerViewController{
                middle.categorey=categorey
                middle.name=name
                middle.about=about
                middle.latitudeString=latitudeString
                middle.longitudeString=longitudeString
                middle.addressString=addressString
                middle.cents=cents
                middle.condition=condition
                middle.images=images
                middle.nextItemDelegate=self
                middle.dismissDelegate=self
                middle.coverImagePath=coverImagePath
                middle.keyString=keyString
                middle.user=user
                self.userDelegate=middle
                if let tempUserImage=tempUserImage{
                    middle.tempUserImage=tempUserImage
                }
                
                
            }
        
        }
        if segue.identifier=="containerToChat"{
            if let vc:ChatContainerViewController=segue.destination as? ChatContainerViewController{
                vc.keyString=keyString
                vc.otherUser=self.user
//                vc.senderId=FIRAuth.auth()?.currentUser?.uid
//                vc.senderDisplayName=vc.senderId
                let frame=self.view.frame
                let newFrame=CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height-self.topInset)
                vc.frame=newFrame
                print(newFrame.height)
                print(vc.frame?.height)
            

            

            }
        


    }
}
    
}


extension FirstContainerViewController:PulleyDrawerViewControllerDelegate{
    func partialRevealDrawerHeight() -> CGFloat {
        //
        return 20.0
    }

    func collapsedDrawerHeight() -> CGFloat {
        //
        return 20.0
    }

    func supportedDrawerPositions() -> [PulleyPosition]{
        return [.collapsed,.open,.closed
        ]
    }

}

extension FirstContainerViewController:NextItemDelegate,DismissDelgate,UserDelegate{
    func goToNextItem() {
        nextItemDelegate?.goToNextItem()
    }
    func switchCurrentVC() {
        vcToDismiss?.switchCurrentVC()
        dismissDelegate?.switchCurrentVC()
        self.dismiss(animated: false, completion: nil)
    }
    func imageLoaded(image: UIImage, user: User, index: Int?) {
        self.userDelegate?.imageLoaded(image: image, user: user, index: index)
        tempUserImage=image
    }
}
