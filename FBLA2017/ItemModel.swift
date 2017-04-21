//
//  Item.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/21/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import Firebase

protocol ItemDelegate{
    func doneLoading(item:Item)
    
}

class Item{
    var images:[UIImage]?=nil
    var categorey:String?=nil
    var name:String?=nil
    var about:String?=nil
    var latitudeString:String?=nil
    var longitudeString:String?=nil
    var addressString:String?=nil
    var cents:Int?=nil
    var condition:Int?=nil
    var keyString:String?=nil
    var coverImagePath:String?=nil
    var userID:String?=nil
    var user:User?=nil
    
    
    var delegate:ItemDelegate?=nil
    
    func load(keyString:String){
        
        
        
        var images=[UIImage]()
        var name:String?=nil
        var about:String?=nil
        var categorey:String?=nil
        var latitudeString:String?=nil
        var longitudeString:String?=nil
        var addressString:String?=nil
        var cents:Int?=nil
        var condition:Int?=nil
        var userID:String?=nil
        
        
        
        
        let ref = FIRDatabase.database().reference().child("items").child(keyString)
        let user=User()
        
        ref.observe(.value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            name = value?["title"] as? String ?? ""
            about = value?["about"] as? String ?? ""
            categorey = value?["category"] as? String ?? ""
            latitudeString = value?["locationLatitude"] as? String ?? ""
            longitudeString = value?["locationLongitude"] as? String ?? ""
            addressString = value?["locationString"] as? String ?? ""
            condition = value?["condition"] as? Int ?? 0
            cents = value?["cents"] as? Int ?? 0
            userID = value?["userID"] as? String ?? ""
            user.setupUser(id: userID!, isLoggedIn: false)

            
        })
        let storage = FIRStorage.storage()
        ref.child("imagePaths").observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var i=0
                for snapshot in snapshots {
                    if let path = snapshot.value as? String {
                        let imagePath = storage.reference(forURL: path)
                        imagePath.data(withMaxSize: 1 * 6000 * 6000) { data, error in
                            if let error = error {
                                // Uh-oh, an error occurred!
                            } else {
                                let image = UIImage(data: data!)
                                images.append(image!)
                                print(i)
                                i+=1
                                if i==snapshots.count{
                                    self.categorey=categorey
                                    self.name=name
                                    self.about=about
                                    self.latitudeString=latitudeString
                                    self.longitudeString=longitudeString
                                    self.addressString=addressString
                                    self.cents=cents
                                    self.condition=condition
                                    self.images=images
                                    self.keyString=keyString
                                    self.user=user
                                    
                                    self.delegate?.doneLoading(item: self)
                                

                                }
                            }
                        }
                        
                    }
                }
            }
            
        })
    }
    }
