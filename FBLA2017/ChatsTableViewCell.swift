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

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.text=user?.uid
        self.dateLabel.text=date

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
