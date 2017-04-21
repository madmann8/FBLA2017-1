//
//  ChatsTableViewCell.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/20/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user:User?=nil{
        didSet{
            //
        }
    }
    
    
    var isGlobal:Bool?=nil
    var chatPath:String?=nil
    var date:String?=nil
    var name:String?=nil
    var img:UIImage?=nil


    
}

extension ChatsTableViewCell:UserDelegate{
    func imageLoaded(image: UIImage, user: User, index: Int?) {
        self.imageView?.image=image
    }

}
