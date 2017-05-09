//
//  WalkthroughMainViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 5/7/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit

protocol WalkthroughDismissedDelegate {
    func walkthroughDismissed()
}

class WalkthroughMainViewController: UIViewController, UIPageViewControllerDelegate, PageControlDelegate {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pageIndicator: UIPageControl!

    var pages = [UIViewController]()

    var delegate: WalkthroughDismissedDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.layer.cornerRadius = doneButton.layer.frame.height / 2

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "mainWTtoPages" {
        let vc = segue.destination as! WalkthroughPageViewController
                vc.pageControlDelegate = self

        }
    }

    func update(count: Int, index: Int) {
        self.pageIndicator.currentPage = index
        self.pageIndicator.numberOfPages = count
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func DoneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        delegate?.walkthroughDismissed()
    }

}
