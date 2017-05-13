//
//  WalkthroughSinglePageViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 5/7/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import ChameleonFramework


//View Controller that represnts a page in the walkthrough page view controller
class WalkthroughSinglePageViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    var index: Int?
    
    var nibView: UIView?
    
    var viewToLoad: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nibView = (UINib(nibName: "Slide\(index!)", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView)
        
        self.mainView.addSubview(nibView!)
        
        nibView?.frame = CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height)
        
        
        mainView.layer.cornerRadius = 10
        mainView.clipsToBounds = true
        self.view.backgroundColor = UIColor.flatWatermelon
        
    }
    
    
}
