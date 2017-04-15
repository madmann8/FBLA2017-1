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
    
    var nextItemDelegate:NextItemDelegate?=nil
    var dismissDelegate:DismissDelgate?=nil
 
    @IBOutlet weak var primaryView: UIView!
    @IBOutlet weak var secondaryView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate=self
        setNeedsSupportedDrawerPositionsUpdate()
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
            if let middle:InfoContainerViewController=segue.destination as! InfoContainerViewController{
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
            }
        
        }
        if segue.identifier=="containerToChat"{
            if let vc:ItemChatViewController=segue.destination as! ItemChatViewController{
                vc.keyString=keyString
                vc.senderId=FIRAuth.auth()?.currentUser?.uid
                vc.senderDisplayName=vc.senderId
                print(vc.view.frame.height)
                let frame=self.view.frame
                let newHeight=frame.height*0.8
                print(newHeight)
                let newFrame=CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height-self.topInset)
                vc.frame=newFrame
            

            

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

extension FirstContainerViewController:NextItemDelegate,DismissDelgate{
    func goToNextItem() {
        nextItemDelegate?.goToNextItem()
    }
    func switchCurrentVC() {
        dismissDelegate?.switchCurrentVC()
    }
}
