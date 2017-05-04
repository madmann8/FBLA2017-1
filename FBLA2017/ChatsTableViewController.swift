//
//  ChatsTableViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/20/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//
protocol TableHasLoadedDelegate{
    func hasLoaded()
}

protocol ClearCellDelegate{
    func clear()
    func unClear()
}

import UIKit
import NVActivityIndicatorView
import ChameleonFramework
//Outlets cause an error, need to define delegate/datasource
class ChatsTableViewController: UITableViewController,TableHasLoadedDelegate {
    
    var itemKeys=[String]()
    var directChatKeys=[String]()
    var itemCells=currentUser.itemChats
    var directCells=currentUser.directChats
    var loadedItemCells=[ChatsTableViewCell?](repeating: nil, count:currentUser.itemChats.count)
    var loadedDirectCells=[ChatsTableViewCell?](repeating: nil, count:currentUser.directChats.count)
    var cellsToLoad=currentUser.itemChats.count+currentUser.directChats.count
    var cellsLoaded=0
    
    var cellsToClear=[ClearCellDelegate]()
    var activityIndicator:NVActivityIndicatorView?=nil
    
    var readyToLoad=true


var refresher=UIRefreshControl()
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator=ActivityIndicatorLoader.startActivityIndicator(view: self.view)
        refreshData()
    }
    
    var loadCells=false
    
    func hasLoaded(){
//        self.tableView.reloadData()
//        self.viewWillAppear(true)
//        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser.hasLoadedDelegate=self
//        refreshData()
refresher.addTarget(self, action:#selector(refreshData), for: .valueChanged)
//        refresher.beginRefreshing()
// activityIndicator=ActivityIndicatorLoader.startActivityIndicator(view: self.view)
//        refreshData()
    self.tableView.addSubview(refresher)
        self.tableView.separatorStyle = .none
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if (itemCells.count<1 && directCells.count<1){
            return 0
        }
        if !(itemCells.count<1||directCells.count<1){
return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor=UIColor.flatNavyBlue
        header.backgroundColor=UIColor.flatNavyBlue
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 17)


    }
    



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if getSectionType(section: section) == .item {
            return itemCells.count
        }
        return directCells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type=getSectionType(section: indexPath.section)
        if type == .item{
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! ChatsTableViewCell
            print(indexPath.row)
            let cell2=itemCells[indexPath.row]
            cell.hasLoaded=cell2.hasLoaded
            cell.mainImageView?.image=cell2.img
            cell.dateLabel.text=cell2.date
            cell.nameLabel.text=cell2.name
            cell.delegate=cell2
            cell2.item=cell.item
            loadedItemCells[indexPath.row]=cell2
            
            
            if !loadCells{
                if cell.img == nil && cell.mainImageView.image == nil && cell.hasLoaded == false{
                    cell.tableViewDelegate=self
                    cell2.tableViewDelegate=self

                }
                else {
//                    cellLoaded()
                }
            }
            
            cellsToClear.append(cell)
            
            
            return cell2
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! ChatsTableViewCell
        let cell2=directCells[indexPath.row]
        cell.hasLoaded=cell2.hasLoaded
        cell.mainImageView?.image=cell2.img
        cell.dateLabel.text=cell2.date
        cell.nameLabel.text=cell2.name
        cell.delegate=cell2
        cell2.item=cell.item
        loadedDirectCells[indexPath.row]=cell2
        
        
        if !loadCells{
            if cell.img == nil && cell.hasLoaded == false{
                cell.tableViewDelegate=self
                cell2.tableViewDelegate=self
            }
            else {
//                cellLoaded()
            }
        }
        
        cellsToClear.append(cell)

        
        return cell2
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if getSectionType(section: section) == .user{
                return "Users"
            }
                    return "Items"
    }
    
    func getSectionType(section:Int) ->SectionType{
        if section == 0{
            if itemCells.count<1{
                return .user
            }
            if directCells.count<1{
                return .item
            }
            return .item
        }
        return .user

    }
}

enum SectionType{
    case user
    case item
}

extension ChatsTableViewController:ItemDelegate{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if readyToLoad{
        if getSectionType(section: indexPath.section) == .user{
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
            readyToLoad=false
            activityIndicator=ActivityIndicatorLoader.startActivityIndicator(view: self.view)
            cell?.item=item
            
            
        }
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
        self.present(middle, animated: true, completion: nil)
        readyToLoad=true
        
        
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}



extension ChatsTableViewController:ChatsTableViewLoadedDelgate,ChatsTableCanReloadDelegate{
    func cellLoaded(){
        cellsLoaded+=1
        if cellsLoaded>=cellsToLoad{
            doneLoading()
        }
    }
    
    func doneLoading(){
        activityIndicator?.stopAnimating()
//        refresher.removeFromSuperview()
        loadCells=true
//        self.tableView.reloadData()
//        viewDidLoad()
//        self.viewWillAppear(true)
    }
    
    
    func refreshData(){
        if readyToLoad{
        readyToLoad=false
             currentUser.chatTableCanReloadDelegate=self
        
        currentUser.resetLoadedCell()
        }
    }
    func refreshChats(){

        loadCells=true
        self.itemCells.removeAll()
        self.directCells.removeAll()
            loadedItemCells.removeAll()
        loadedDirectCells.removeAll()
        for cell in cellsToClear{
            cell.clear()
        }

        cellsToLoad=0
        cellsLoaded=0
        tableView.reloadData()

        itemCells=currentUser.itemChats
        directCells=currentUser.directChats
         loadedItemCells=[ChatsTableViewCell?](repeating: nil, count:currentUser.itemChats.count)
         loadedDirectCells=[ChatsTableViewCell?](repeating: nil, count:currentUser.directChats.count)
         cellsToLoad=currentUser.itemChats.count+currentUser.directChats.count
         cellsLoaded=cellsToLoad
        cellsToClear.removeAll()
        self.tableView.reloadData()
        readyToLoad=true
//
self.activityIndicator?.stopAnimating()
        refresher.endRefreshing()


//
        self.viewWillAppear(true)
          }
    
    }
