//
//  ChatsTableViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/20/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//
protocol TableHasLoadedDelegate {
    func hasLoaded()
}

protocol ClearCellDelegate {
    func clear()
    func unClear()
}

import UIKit
import NVActivityIndicatorView
import ChameleonFramework
import DZNEmptyDataSet

//Outlets cause an error, need to define delegate/datasource
class ChatsTableViewController: UITableViewController, TableHasLoadedDelegate {

    var itemKeys=[String]()
    var directChatKeys=[String]()
    var itemCells = currentUser.itemChats
    var directCells = currentUser.directChats
    var loadedItemCells=[ChatsTableViewCell?](repeating: nil, count:currentUser.itemChats.count)
    var loadedDirectCells=[ChatsTableViewCell?](repeating: nil, count:currentUser.directChats.count)
    var cellsToLoad = currentUser.itemChats.count + currentUser.directChats.count
    var cellsLoaded = 0

    var cellsToClear=[ClearCellDelegate]()
    var activityIndicator: NVActivityIndicatorView?

    var readyToLoad = true

    var loading = true

var refresher = UIRefreshControl()

    override func viewDidAppear(_ animated: Bool) {
        activityIndicator = ActivityIndicatorLoader.startActivityIndicator(view: self.view)
        refreshData()
    }

    var loadCells = false

    func hasLoaded() {
//        self.tableView.reloadData()
//        self.viewWillAppear(true)
//        viewDidLoad()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.emptyDataSetSource = self
        tableView?.emptyDataSetDelegate = self
        tableView?.tableFooterView = UIView()
        currentUser.hasLoadedDelegate = self
        refresher.addTarget(self, action:#selector(refreshData), for: .valueChanged)
        self.tableView.addSubview(refresher)
        self.tableView.separatorStyle = .none
            }



    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if (itemCells.count < 1 && directCells.count < 1) {
            return 0
        }
        if !(itemCells.count < 1 || directCells.count < 1) {
            return 2
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = UIColor.flatNavyBlue
        header.backgroundColor = UIColor.flatNavyBlue
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if getSectionType(section: section) == .item {
            return itemCells.count
        }
        return directCells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = getSectionType(section: indexPath.section)
        if type == .item {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! ChatsTableViewCell
            print(indexPath.row)
            let cell2 = itemCells[indexPath.row]
            cell.hasLoaded = cell2.hasLoaded
            cell.mainImageView?.image = cell2.img
            cell.dateLabel.text = cell2.date
            cell.nameLabel.text = cell2.name
            cell.delegate = cell2
            cell2.item = cell.item
            loadedItemCells[indexPath.row]=cell2

            if !loadCells {
                if cell.img == nil && cell.mainImageView.image == nil && cell.hasLoaded == false {
                    cell.tableViewDelegate = self
                    cell2.tableViewDelegate = self

                } else {
//                    cellLoaded()
                }
            }

            cellsToClear.append(cell)

            return cell2
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! ChatsTableViewCell
        let cell2 = directCells[indexPath.row]
        cell.hasLoaded = cell2.hasLoaded
        cell.mainImageView?.image = cell2.img
        cell.dateLabel.text = cell2.date
        cell.nameLabel.text = cell2.name
        cell.delegate = cell2
        cell2.item = cell.item
        loadedDirectCells[indexPath.row]=cell2

        if !loadCells {
            if cell.img == nil && cell.hasLoaded == false {
                cell.tableViewDelegate = self
                cell2.tableViewDelegate = self
            } else {
//                cellLoaded()
            }
        }

        cellsToClear.append(cell)

        return cell2

    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if getSectionType(section: section) == .user {
                return "Users"
            }
                    return "Items"
    }

    func getSectionType(section: Int) -> SectionType {
        if section == 0 {
            if itemCells.count < 1 {
                return .user
            }
            if directCells.count < 1 {
                return .item
            }
            return .item
        }
        return .user

    }
}

enum SectionType {
    case user
    case item
}


//MARK - TableView to Item View
extension ChatsTableViewController:ItemDelegate {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if readyToLoad {
        if getSectionType(section: indexPath.section) == .user {
            let cell = loadedDirectCells[indexPath.row]
            let user = cell?.user
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "OtherUserProfile") as! OtherUserProfileViewController
            viewController.loadOtherChat = true
            viewController.loginInUser = currentUser
            viewController.otherUser = user
            present(viewController, animated: true, completion: nil)

        } else {
            let cell = loadedItemCells[indexPath.row]
            let item = Item()
            item.delegate = self
            item.load(keyString: (cell?.itemPath)!)
            readyToLoad = false
            activityIndicator = ActivityIndicatorLoader.startActivityIndicator(view: self.view)
            cell?.item = item

        }
        }
    }

    func doneLoading(item: Item) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let middle = storyboard.instantiateViewController(withIdentifier: "pulley") as! FirstContainerViewController

        middle.nextItemDelegate = nil
        middle.dismissDelegate = nil
        middle.item = item
        middle.openWithChat = true

       activityIndicator?.stopAnimating()
        self.present(middle, animated: true, completion: nil)
        readyToLoad = true

    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}


//MARK: - Refresh control
extension ChatsTableViewController:ChatsTableViewLoadedDelgate, ChatsTableCanReloadDelegate {
    func cellLoaded() {
        cellsLoaded += 1
        if cellsLoaded >= cellsToLoad {
            doneLoading()
        }
    }

    func doneLoading() {
        activityIndicator?.stopAnimating()
        loadCells = true
    }

    func refreshData() {
        activityIndicator?.startAnimating()
        loading = true
        if readyToLoad {
        readyToLoad = false
             currentUser.chatTableCanReloadDelegate = self

        currentUser.resetLoadedCell()
        }
    }
    func refreshChats() {
        loading = false

        loadCells = true
        self.itemCells.removeAll()
        self.directCells.removeAll()
            loadedItemCells.removeAll()
        loadedDirectCells.removeAll()
        for cell in cellsToClear {
            cell.clear()
        }

        cellsToLoad = 0
        cellsLoaded = 0
        tableView.reloadData()

        itemCells = currentUser.itemChats
        directCells = currentUser.directChats
         loadedItemCells=[ChatsTableViewCell?](repeating: nil, count:currentUser.itemChats.count)
         loadedDirectCells=[ChatsTableViewCell?](repeating: nil, count:currentUser.directChats.count)
         cellsToLoad = currentUser.itemChats.count + currentUser.directChats.count
         cellsLoaded = cellsToLoad
        cellsToClear.removeAll()
        self.tableView.reloadData()
        readyToLoad = true
        self.activityIndicator?.stopAnimating()
        refresher.endRefreshing()
        self.viewWillAppear(true)
          }

    }

//MARK - Empty table view
extension ChatsTableViewController:DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if !loading {
            return NSAttributedString(string: "Huh", attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 17) as Any])
        } else {
            return NSAttributedString(string: "", attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 17) as Any])
        }
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if !loading {

            return NSAttributedString(string: "It doesn't look like there are any chats here, either contribute to chats on items or start a chat with another user.", attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 17) as Any])
        } else {
            return NSAttributedString(string: "", attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 17) as Any])
        }
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        if !loading {
            return NSAttributedString(string: "Press Here To Refresh", attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 25) as Any])
        } else {
            return NSAttributedString(string: "", attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 17) as Any])
        }

    }

    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        refreshData()
    }

}
