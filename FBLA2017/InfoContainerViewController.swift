//
//  InfoViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/13/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import Popover
import FirebaseDatabase
import FirebaseAuth

protocol NextItemDelegate {
    func goToNextItem()
}

protocol DismissDelgate{
    func switchCurrentVC()
}


class InfoContainerViewController: UIViewController {

    var images:[UIImage]?=nil
    var categorey:String?=nil
    var name:String?=nil
    var about:String?=nil
    var latitudeString:String?=nil
    var longitudeString:String?=nil
    var addressString:String?=nil
    var cents:Int?=nil
    var condition:Int?=nil
    var coverImagePath:String?=nil
    var userID:String?=nil

    var hasLiked=false
    
    var keyString:String?=nil
    
    var nextItemDelegate: NextItemDelegate?=nil
    var dismissDelegate:DismissDelgate?=nil
    
    var ref:FIRDatabaseReference?=nil
    
    var user:User?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user?.delegate=self
        ref=FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("likedCoverImages")
        ref?.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var i=0
                for snapshot in snapshots {
                    if let path = snapshot.key as? String {
                        print("Local path\(self.keyString!)")
                        print(path)
                        if path==self.keyString{
                            self.hasLiked=true
                        }
                        
                    }
                }
            }
            
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showPageVC" {
            let pageDesitnation=segue.destination as! PageViewController
            pageDesitnation.images=self.images
            titleLabel.text=name
            pageDesitnation.nextItemDelegate=self
            if let cents=cents,let rating=condition {
                    costLabel.text=String(describing: cents)
                    ratingLabel.text=String(describing: rating)

                }
            }
    }
    
    @IBAction func moreInfoButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc=storyboard.instantiateViewController(withIdentifier: "detailTop") as! MoreDetailsViewController
        vc.categorey=self.categorey
        vc.name=self.name
        vc.about=self.about
        vc.latitudeString=self.latitudeString
        vc.longitudeString=self.longitudeString
        vc.addressString=self.addressString
        vc.cents=self.cents
        vc.condition=self.condition
        
        
        let sizeToSubtract=moreInfoButtonToTopConstraint.constant*(-1.4)
        let newFrame=CGRect(x: vc.view.frame.minX, y: vc.view.frame.minY, width: vc.view.frame.width-10, height: vc.view.frame.height-sizeToSubtract)
        vc.view.frame=newFrame
        print(newFrame.height)
        print(newFrame.width)
        let point=CGPoint(x: moreInfoButton.center.x, y: moreInfoButton.center.y-(-1.0)*moreInfoButton.frame.height/2)
        let popover = Popover()
        popover.show(vc.view!, point: point)

    }
    @IBAction func likeButtonPressed() {

        if hasLiked{
            ref?.child("\(keyString!)").removeValue()
            hasLiked=false
        }
        else {
            ref?.child("\(keyString!)").setValue("\(coverImagePath!)")
            hasLiked=true
        }
        
        
    }
 
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        dismissDelegate?.switchCurrentVC()
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var moreInfoButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
     @IBOutlet var moreInfoButtonToTopConstraint: NSLayoutConstraint!

    
    @IBAction func profileButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "OtherUserProfile") as! OtherUserProfileViewController
        viewController.otherUser=self.user
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }

    
}

extension InfoContainerViewController:NextItemDelegate{
    func goToNextItem() {
        self.nextItemDelegate?.goToNextItem()

    }
}

extension InfoContainerViewController:UserDelegate{
    func imageLoaded(image: UIImage) {
        self.profileImage.image=image

    }

 
}
