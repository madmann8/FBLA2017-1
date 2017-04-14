//
//  InfoViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/13/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import Popover

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

    
    var keyString:String?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        print(vc.view.frame.height)
        let sizeToSubtract=moreInfoButtonToTopConstraint.constant*(-1.4)
        let newFrame=CGRect(x: vc.view.frame.minX, y: vc.view.frame.minY, width: vc.view.frame.width-10, height: vc.view.frame.height-sizeToSubtract)
        vc.view.frame=newFrame
        print(vc.view.frame.height)
        let point=CGPoint(x: moreInfoButton.center.x, y: moreInfoButton.center.y-(-1.0)*moreInfoButton.frame.height/2)
        let popover = Popover()
        popover.show(vc.view!, point: point)

    }

    @IBAction func exitButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var moreInfoButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
     @IBOutlet var moreInfoButtonToTopConstraint: NSLayoutConstraint!

    
    
}
