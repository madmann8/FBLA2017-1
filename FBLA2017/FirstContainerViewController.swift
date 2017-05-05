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

class FirstContainerViewController: PulleyViewController {

    var vcToDismiss: FirstContainerViewController?
    var userDelegate: UserDelegate?
    var tempUserImage: UIImage?
    var item: Item?
    var openWithChat: Bool = false

    var nextItemDelegate: NextItemDelegate?
    var dismissDelegate: DismissDelgate?

    @IBOutlet weak var primaryView: UIView!
    @IBOutlet weak var secondaryView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setNeedsSupportedDrawerPositionsUpdate()
        if openWithChat {
            self.setDrawerPosition(position: .open)
        }
//        user.setupUser(id: userID!, isLoggedIn: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.primaryContentContainerView = self.primaryView
        self.drawerContentContainerView = self.secondaryView
        if segue.identifier=="toSecondContainer"{
            if let middle: InfoContainerViewController = segue.destination as? InfoContainerViewController {
                middle.item=item
                middle.nextItemDelegate = self
                middle.dismissDelegate = self
                self.userDelegate = middle
                if let tempUserImage = tempUserImage {
                    middle.tempUserImage = tempUserImage
                }

            }

        }
        if segue.identifier=="containerToChat"{
            if let vc: ChatContainerViewController = segue.destination as? ChatContainerViewController {
                
                vc.keyString = self.item?.keyString
                vc.otherUser = self.item?.user
                let frame = self.view.frame
                let newFrame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height - self.topInset)
                vc.frame = newFrame

            }

    }
}

}

extension FirstContainerViewController:PulleyDrawerViewControllerDelegate {
    func partialRevealDrawerHeight() -> CGFloat {
        //
        return 20.0
    }

    func collapsedDrawerHeight() -> CGFloat {
        //
        return 20.0
    }

    func supportedDrawerPositions() -> [PulleyPosition] {
        return [.collapsed, .open, .closed
        ]
    }

}

extension FirstContainerViewController:NextItemDelegate, DismissDelgate, UserDelegate {
    func goToNextItem() {
        nextItemDelegate?.goToNextItem()
    }
    func switchCurrentVC(shouldReload: Bool) {
        vcToDismiss?.switchCurrentVC(shouldReload:shouldReload )
        dismissDelegate?.switchCurrentVC(shouldReload:shouldReload )
        self.dismiss(animated: false, completion: nil)
    }
    func imageLoaded(image: UIImage, user: User, index: Int?) {
        self.userDelegate?.imageLoaded(image: image, user: user, index: index)
        tempUserImage = image
    }
}
