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
import NVActivityIndicatorView
import ChameleonFramework

protocol NextItemDelegate {
    func goToNextItem()
}

protocol DismissDelgate {
    func switchCurrentVC(shouldReload: Bool)
}

class InfoContainerViewController: UIViewController {

    var images: [UIImage]?
    var categorey: String?
    var name: String?
    var about: String?
    var latitudeString: String?
    var longitudeString: String?
    var addressString: String?
    var coverImageKey: String?
    var item: Item?
    var cents: Int?=nil {
        didSet {
            let num: Double = Double(cents!) / 100.0
            let formatter = NumberFormatter()
            formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
            formatter.numberStyle = .currency
            if let formattedAmount = formatter.string(from: num as NSNumber) {
                dollarsString = "\(formattedAmount)"
            }
        }
    }
    var condition: Int?
    var coverImagePath: String?
    var userID: String?
    var dollarsString: String?
    var hasLiked = false
    var tempUserImage: UIImage?

    var keyString: String?

    var nextItemDelegate: NextItemDelegate?
    var dismissDelegate: DismissDelgate?

    var ref: FIRDatabaseReference?

    var user: User?

    var activitityIndicator: NVActivityIndicatorView?

    @IBOutlet weak var favoriteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        user?.delegate = self
        ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("likedCoverImages")
        ref?.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var i = 0
                for snapshot in snapshots {
                    if let path = snapshot.key as? String {
                        print("Local path\(self.keyString!)")
                        print(path)
                        if path == self.keyString {
                            self.hasLiked = true
                        }

                    }
                }
            }

        })

        if (user?.uid == currentUser.uid) {
            print(user?.uid)
            print (currentUser.uid)
            print(user?.displayName)
            print(currentUser.displayName)

            soldButton.isHidden = false
            soldButton.layer.cornerRadius = soldButton.frame.height / 2
            profileButton.isHidden = true
            profileImage.isHidden = true
            ratingLabel.isHidden = true
            conditionTitleLabel.isHidden = true
            titleLabel.isHidden = true
            costLabel.isHidden = true

        }
        // Do any additional setup after loading the view.
    }

    func setupViews() {
        if let tempUserImage = self.tempUserImage {
            self.profileImage.image = tempUserImage
        } else {
            activitityIndicator = ActivityIndicatorLoader.startActivityIndicator(view: profileImage)
        }
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.flatGrayDark.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true

        if let rating: Int = condition, let dollarsString: String = dollarsString {
            costLabel.text="Asking Price: \(dollarsString)"
            ratingLabel.text="\(String(describing: rating))/5"

        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showPageVC" {
            let pageDesitnation = segue.destination as! PageViewController
            pageDesitnation.images = self.images
            titleLabel.text = name
            pageDesitnation.nextItemDelegate = self

        }
    }

    @IBAction func moreInfoButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailTop") as! MoreDetailsViewController
        vc.categorey = self.categorey
        vc.name = self.name
        vc.about = self.about
        vc.latitudeString = self.latitudeString
        vc.longitudeString = self.longitudeString
        vc.addressString = self.addressString
        vc.cents = self.cents
        vc.condition = self.condition
        vc.dollarString = self.dollarsString
        vc.user = user
        vc.profileImageView = profileImage

        let sizeToSubtract = moreInfoButtonToTopConstraint.constant * (-1.4)
        let newFrame = CGRect(x: vc.view.frame.minX, y: vc.view.frame.minY, width: vc.view.frame.width - 10, height: vc.view.frame.height - sizeToSubtract)
        vc.view.frame = newFrame
        print(newFrame.height)
        print(newFrame.width)
        let point = CGPoint(x: moreInfoButton.center.x, y: moreInfoButton.center.y - (-1.0) * moreInfoButton.frame.height / 2)
        let popover = Popover()
        popover.show(vc.view!, point: point)

    }
    @IBAction func likeButtonPressed() {

        if hasLiked {
            favoriteButton.setImage(#imageLiteral(resourceName: "HeartEmpty"), for: .normal)
            ref?.child("\(keyString!)").removeValue()
            hasLiked = false
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "HeartFilled"), for: .normal)
            ref?.child("\(keyString!)").setValue("\(coverImagePath!)")
            hasLiked = true
        }

    }

    @IBAction func exitButtonPressed(_ sender: UIButton) {
        dismissDelegate?.switchCurrentVC(shouldReload: false)
    }
    @IBOutlet var moreInfoButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet var moreInfoButtonToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var soldButton: UIButton!
    @IBOutlet weak var conditionTitleLabel: UILabel!

    @IBAction func profileButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let viewController = storyboard.instantiateViewController(withIdentifier: "OtherUserProfile") as! OtherUserProfileViewController
        viewController.otherUser = self.user
        present(viewController, animated: true, completion: nil)
    }

    @IBAction func soldButtonPressed() {

        let alertController = UIAlertController(title: "Mark as Sold", message: "Are you sure you want to mark your product as sold?", preferredStyle: .alert)

        // Create the actions
        let okAction = UIAlertAction(title: "Mark as Sold", style: UIAlertActionStyle.default) {
            _ in
            NSLog("OK Pressed")
            self.removeItem(alertController: alertController)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            _ in
            NSLog("Cancel Pressed")
        }

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        // Present the controller
        self.present(alertController, animated: true, completion: nil)

    }

    func removeItem(alertController: UIAlertController) {
        let ref = FIRDatabase.database().reference()

        ref.child("users").child(user!.uid).child("coverImages").observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snapshot in snapshots {
                    if let path = snapshot.key as? String {
                        if let path2 = snapshot.value as? String {
                            if path2 == self.coverImagePath {

                        ref.child("users").child(self.user!.uid).child("coverImages").child(path).removeValue()
                                ref.child("users").child(self.user!.uid).child("itemChats").child(path).removeValue()

                        let path: String = self.keyString!
                        ref.child("items").child(path).removeValue()
                        ref.child("coverImagePaths").child(self.keyString!).removeValue()
                        alertController.dismiss(animated: false, completion: nil)
                                if let dd: FirstContainerViewController = self.dismissDelegate as! FirstContainerViewController {
                                    if dd.dismissDelegate == nil {
                                        self.item?.deleted = true
                                        self.dismissDelegate?.switchCurrentVC(shouldReload: false)
                                    } else {
                                        self.dismissDelegate?.switchCurrentVC(shouldReload: true)

                                    }
                                }
                    break
                            }}
                    }
                }
            }

        })

    }

}

extension InfoContainerViewController:NextItemDelegate {
    func goToNextItem() {
        self.nextItemDelegate?.goToNextItem()

    }
}

extension InfoContainerViewController:UserDelegate {
    func imageLoaded(image: UIImage, user: User, index: Int?) {
        self.profileImage.image = image

    }

}
