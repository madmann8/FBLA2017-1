//
//  WalkthroughSinglePageViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 5/7/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import ChameleonFramework

class WalkthroughSinglePageViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!

    var index: Int?

    var viewToLoad: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()

        let tempView = UINib(nibName: "Slide\(index!)", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView

        self.mainView.addSubview(tempView)

mainView.layer.cornerRadius = 10
        mainView.clipsToBounds = true
        self.view.backgroundColor = UIColor.flatWatermelon

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}