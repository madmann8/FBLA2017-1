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
    func tranferImage(image:UIImage)
    
}


protocol ChatsTableViewLoadedDelgate {
    func cellLoaded()
    
}


class ChatsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!{
        didSet{
            self.mainImageView.layer.cornerRadius=10
            mainImageView.clipsToBounds = true
        }
        
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var background: UIView!
    
    var hasLoaded=false

    
    
    var user:User?=nil
    
    var delegate:TranferDelegate?=nil
    var chatImageLoadedDelegate:ChatImageLoadedDelegate?=nil

    
    var tableViewDelegate:ChatsTableViewLoadedDelgate?=nil{
        didSet{
            if let img=self.img{
                if !hasLoaded{
                self.tableViewDelegate?.cellLoaded()
                    hasLoaded=true
                }
        }
        }
    }
    
    var isGlobal:Bool?=nil
    var chatPath:String?=nil
    var date:String?=nil
    var name:String?=nil
    var img:UIImage?=nil
    var item:Item?=nil
    var coverImagePath:String?=nil{
        didSet{
            loadCoverImage()
        }
    }
    var itemPath:String?=nil
    
    override func awakeFromNib() {
        self.background.layer.cornerRadius = 10
        self.background.layer.masksToBounds = true
        self.mainImageView.layer.cornerRadius=10
        mainImageView.clipsToBounds = true

    }
    


    
}

extension ChatsTableViewCell:UserDelegate,TranferDelegate{
    func tranferImage(image: UIImage) {
        if let mainIV=self.mainImageView {
            mainIV.image=image
            self.img=image

        }
        else {
            self.img?=image
            if !hasLoaded{
                self.tableViewDelegate?.cellLoaded()
                hasLoaded=true
            }
        }
    }

    func imageLoaded(image: UIImage, user: User, index: Int?) {
        delegate?.tranferImage(image: image)
        if let mainIV=self.mainImageView {
            mainIV.image=image
            self.img=image
            if !hasLoaded{
                self.tableViewDelegate?.cellLoaded()
                hasLoaded=true
            }
        }
        else {
            self.img=image
        }
        

    }
    
    func loadCoverImage() {
        let storage = FIRStorage.storage()
        let path = self.coverImagePath!
            let coverImagePath = storage.reference(forURL: path)
            coverImagePath.data(withMaxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                } else {
                    let image = UIImage(data: data!)
                    self.delegate?.tranferImage(image: image!)
                    if let mainIV=self.mainImageView {
                        mainIV.image=image
                        self.img=image
                        if !self.hasLoaded{
                            self.tableViewDelegate?.cellLoaded()
                             self.chatImageLoadedDelegate?.chatUserImageLoaded()

                            self.hasLoaded=true
                        }                    }
                    else {
                        self.img=image
                        if !self.hasLoaded{
                            self.tableViewDelegate?.cellLoaded()
                            self.chatImageLoadedDelegate?.chatUserImageLoaded()

                            self.hasLoaded=true
                        }
                    }

                   
                }
            }
            
        
    }
    

}
 
 extension ChatsTableViewCell: ClearCellDelegate{
    func clear(){
        removeFromSuperview()
//        for view in self.subviews{
//            view.isHidden=true
//            removeFromSuperview()
//        }


    }
    func unClear(){
        for view in self.subviews{
            view.isHidden=false
        }
    }
 }

