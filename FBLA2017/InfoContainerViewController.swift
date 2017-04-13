//
//  InfoViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/13/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit

class InfoContainerViewController: UIViewController {

    var images:[UIImage]?=nil
    var name:String?=nil
    var about:String?=nil
    var rating:Int?=nil
    var cents:Int?=nil

    
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
            if let cents=cents,let rating=rating {
                    costLabel.text=String(describing: cents)
                    ratingLabel.text=String(describing: rating)

                }
            }
                    
    }
    

    @IBAction func exitButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    /*

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
