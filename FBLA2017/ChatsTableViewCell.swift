//
//  ChatsTableViewCell.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/20/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import FirebaseStorage

protocol TranferDelegate {
    func tranferImage(image: UIImage)

}

protocol ChatsTableViewLoadedDelgate {
    func cellLoaded()

}

class ChatsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView! {
        didSet {
            self.mainImageView.layer.cornerRadius = 10
            mainImageView.clipsToBounds = true
        }

    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var background: UIView!

    var hasLoaded = false
    var user: User?
    var delegate: TranferDelegate?
    var chatImageLoadedDelegate: ChatImageLoadedDelegate?
    var tableViewDelegate: ChatsTableViewLoadedDelgate?=nil {
        didSet {
            if self.img != nil {
                if !hasLoaded {
                self.tableViewDelegate?.cellLoaded()
                    hasLoaded = true
                }
        }
        }
    }
    var isGlobal: Bool?
    var chatPath: String?
    var date: String?
    var name: String?
    var img: UIImage?
    var item: Item?
    var coverImagePath: String?=nil {
        didSet {
            loadCoverImage()
        }
    }
    var itemPath: String?

    override func awakeFromNib() {
        self.background.layer.cornerRadius = 10
        self.background.backgroundColor = UIColor.flatWatermelon
        self.background.alpha = 0.7
        self.background.layer.masksToBounds = true
        self.mainImageView.layer.cornerRadius = 10
        mainImageView.clipsToBounds = true

    }

}

// MARK - Load image
extension ChatsTableViewCell:UserDelegate, TranferDelegate {
    func tranferImage(image: UIImage) {
        if let mainIV = self.mainImageView {
            mainIV.image = image
            self.img = image

        } else {
            self.img?=image
            if !hasLoaded {
                self.tableViewDelegate?.cellLoaded()
                hasLoaded = true
            }
        }
    }

    func imageLoaded(image: UIImage, user: User, index: Int?) {
        delegate?.tranferImage(image: image)
        if let mainIV = self.mainImageView {
            mainIV.image = image
            self.img = image
            if !hasLoaded {
                self.tableViewDelegate?.cellLoaded()
                hasLoaded = true
            }
        } else {
            self.img = image
        }

    }

    func loadCoverImage() {
        let storage = FIRStorage.storage()
        let path = self.coverImagePath!
            let coverImagePath = storage.reference(forURL: path)
            coverImagePath.data(withMaxSize: 1 * 1_024 * 1_024) { data, error in
                if error != nil { } else {
                    let image = UIImage(data: data!)
                    self.delegate?.tranferImage(image: image!)
                    if let mainIV = self.mainImageView {
                        mainIV.image = image
                        self.img = image
                        if !self.hasLoaded {
                            self.tableViewDelegate?.cellLoaded()
                             self.chatImageLoadedDelegate?.chatUserImageLoaded()

                            self.hasLoaded = true
                        }                    }
                    else {
                        self.img = image
                        if !self.hasLoaded {
                            self.tableViewDelegate?.cellLoaded()
                            self.chatImageLoadedDelegate?.chatUserImageLoaded()

                            self.hasLoaded = true
                        }
                    }

                }
            }
    }

}

//MARK: -Clear Cell
//THis is used to make the views in these cells hidden as a workaround for the refresh
 extension ChatsTableViewCell: ClearCellDelegate {
    func clear() {
        removeFromSuperview()
    }
    func unClear() {
        for view in self.subviews {
            view.isHidden = false
        }
    }
 }
