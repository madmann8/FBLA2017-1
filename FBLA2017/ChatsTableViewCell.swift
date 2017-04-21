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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var user:User?=nil
    var isGlobal:Bool?=nil
    var chatPath:String?=nil
    var date:String?=nil
    var name:String?=nil
    var img:UIImage?=nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    override func didMoveToSuperview() {
        self.titleLabel=UILabel()
        self.dateLabel=UILabel()
        self.titleLabel.text=user?.uid
        self.dateLabel.text=date
//        self.imageView?.image=img

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
