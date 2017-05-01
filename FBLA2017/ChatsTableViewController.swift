//
//  ChatsTableViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/20/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
//Outlets cause an error, need to define delegate/datasource
class ChatsTableViewController: UITableViewController {
    
    var itemKeys=[String]()
    var directChatKeys=[String]()
    let itemCells=currentUser.itemChats
    let directCells=currentUser.directChats
    var loadedItemCells=[ChatsTableViewCell?](repeating: nil, count:currentUser.itemChats.count)
    var loadedDirectCells=[ChatsTableViewCell?](repeating: nil, count:currentUser.directChats.count)
    
    var activityIndicator:NVActivityIndicatorView?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if !(itemCells.count<1||directCells.count<1){
return 2
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section != 0{
            if itemCells.count<1{
                return directCells.count
            }
            if directCells.count<0{
                return itemCells.count
            }
            return itemCells.count
        }
        return directCells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! ChatsTableViewCell
            print(indexPath.row)
            let cell2=itemCells[indexPath.row]
            cell.mainImageView?.image=cell2.img
            cell.dateLabel.text=cell2.date
            cell.nameLabel.text=cell2.name
            cell.delegate=cell2
            loadedItemCells[indexPath.row]=cell2
            
                      return cell2
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! ChatsTableViewCell
        let cell2=directCells[indexPath.row]
        cell.mainImageView?.image=cell2.img
        cell.dateLabel.text=cell2.date
        cell.nameLabel.text=cell2.name
        cell.delegate=cell2
        cell2.item=cell.item
        loadedDirectCells[indexPath.row]=cell2
        
        return cell2
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section != 0{
            if itemCells.count<1{
                return "Users"
            }
            if directCells.count<0{
                return "Items"
            }
            return "Items"
        }
        return "Users"
        }
}


extension ChatsTableViewController:ItemDelegate{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section==0 && directCells.count>0){
            let cell=loadedDirectCells[indexPath.row]
            let user=cell?.user
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "OtherUserProfile") as! OtherUserProfileViewController
            viewController.loadOtherChat=true
            viewController.loginInUser=currentUser
            viewController.otherUser=user
            present(viewController, animated: true, completion: nil)
            
            
        }
        else {
            let cell=loadedItemCells[indexPath.row]
            let item=Item()
            item.delegate=self
            item.load(keyString: (cell?.itemPath)!)
            activityIndicator=ActivityIndicatorLoader.startActivityIndicator(view: self.view)
            cell?.item=item
            
            
        }
    }
    
    func doneLoading(item:Item) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let middle=storyboard.instantiateViewController(withIdentifier: "pulley") as! FirstContainerViewController
        middle.categorey=item.categorey
        middle.name=item.name
        middle.about=item.about
        middle.latitudeString=item.latitudeString
        middle.longitudeString=item.longitudeString
        middle.addressString=item.addressString
        middle.cents=item.cents
        middle.condition=item.condition
        middle.images=item.images
        middle.keyString=item.keyString
        middle.nextItemDelegate=nil
        middle.dismissDelegate=nil
        middle.coverImagePath=item.coverImagePath
        middle.user=item.user
        middle.item=item
        middle.openWithChat=true
        
        
        
       activityIndicator?.stopAnimating()
        self.present(middle, animated: false, completion: nil)
        
        
        
    }
}

