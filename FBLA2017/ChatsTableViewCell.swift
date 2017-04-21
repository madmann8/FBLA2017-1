//
//  ChatsTableViewCell.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/20/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit

protocol TranferDelegate {
    func tranferImage(image:UIImage)
}

class ChatsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
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
    {
        didSet{
            //
        }
    }

//    self.textLabel?.text=user.displayName
//    self.detailTextLabel?.text=self.date
    
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

    func imageLoaded(image: UIImage) {
        delegate?.tranferImage(image: image)
        if let mainIV=self.mainImageView {
            mainIV.image=image
        }
        else {
            self.img=image
        }

    }
    

}
