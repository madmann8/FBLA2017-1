//
//  GroupsTableViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 5/6/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import FirebaseDatabase
import ChameleonFramework
import Presentr
import FirebaseAuth


//View Controller to control the group selection view table 
class GroupsTableViewController: UITableViewController {

    var cells=[GroupsTableViewCell]()

    var currentSelectedCell: GroupsTableViewCell?

    var nameToUpload: String?

    @IBOutlet weak var chooseButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseButton.setTitleColor(UIColor.flatNavyBlueDark, for: .normal)
        loadCells()
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sourceCell = cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for:indexPath) as! GroupsTableViewCell
        cell.groupName = sourceCell.groupName
        cell.groupPath = sourceCell.groupPath
        cell.groupNameLabel.text = cell.groupName
        cells[indexPath.row]=cell

       return cells[indexPath.row]
    }

    func loadCells() {
        let ref = FIRDatabase.database().reference().child("groups")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                let maxCells = snapshots.count
                for snapshot in snapshots {
                if let path = snapshot.key as? String, let name = snapshot.value as? String {
                    let cell = GroupsTableViewCell()
                    cell.groupPath = path
                    cell.groupName = name
                    self.cells.append(cell)
                    if self.cells.count >= maxCells {
                        self.refreshTable()
                    }
                    }
                }
            }

            // ...
        }) { (error) in
            ErrorGenerator.presentError(view: self, type: "Groups", error: error)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = cells[indexPath.row]
        cell.checkMark.isHidden = false
        if cell != currentSelectedCell {
        currentSelectedCell?.checkMark.isHidden = true
        currentSelectedCell = cell
        }}

    func refreshTable() {
        self.tableView.reloadData()
        viewDidAppear(false)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    @IBAction func chooseButtonPressed() {
        if currentSelectedCell != nil {
        currentUser.groupPath = (currentSelectedCell?.groupPath)!
            currentUser.loadGroup()

            let ref = FIRDatabase.database().reference().child(currentGroup).child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("displayName")
            ref.setValue(nameToUpload)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let viewController = storyboard.instantiateViewController(withIdentifier: "MainView")
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)

            UIApplication.shared.keyWindow?.rootViewController = viewController

        }

    }
}
    extension GroupsTableViewController:MakeGroupDelegate {
        func toMainView() {

            if let nameToUpload = nameToUpload {
            let ref = FIRDatabase.database().reference().child(currentGroup).child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("displayName")
            ref.setValue(nameToUpload)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let viewController = storyboard.instantiateViewController(withIdentifier: "MainView")
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)

            UIApplication.shared.keyWindow?.rootViewController = viewController

        }
        @IBAction func addGroupButtonPressed(_ sender: Any) {
            let width = ModalSize.fluid(percentage: 0.7)
            let height = ModalSize.fluid(percentage: 0.3)
            let center = ModalCenterPosition.center

            let presentationType = PresentationType.custom(width: width, height: height, center: center
            )
            let dynamicSizePresenter = Presentr(presentationType: presentationType)
            let dynamicVC = storyboard!.instantiateViewController(withIdentifier: "MakeGroup") as! MakeGroupPopoverViewController
            dynamicVC.delegate = self
            customPresentViewController(dynamicSizePresenter, viewController: dynamicVC, animated: true, completion: nil)

               }

    }
