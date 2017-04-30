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


class ChatsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!{
        didSet{
            self.mainImageView.layer.cornerRadius=10
            mainImageView.clipsToBounds = true
        }
        
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var user:User?=nil{
        didSet{
            //
        }
    }
    
    var delegate:TranferDelegate?=nil
    
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
        self.mainImageView.layer.cornerRadius=10
        mainImageView.clipsToBounds = true

    }
    


    
}

extension ChatsTableViewCell:UserDelegate,TranferDelegate{
    func tranferImage(image: UIImage) {
        if let mainIV=self.mainImageView {
            mainIV.image=image
        }
        else {
            self.img?=image
        }
    }

    func imageLoaded(image: UIImage, user: User, index: Int?) {
        delegate?.tranferImage(image: image)
        if let mainIV=self.mainImageView {
            mainIV.image=image
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
                        

                    }
                    else {
                        self.img=image

                    }

                   
                }
            }
            
        
    }
    

}

