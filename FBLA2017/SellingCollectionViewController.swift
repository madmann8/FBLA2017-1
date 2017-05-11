import UIKit
import NVActivityIndicatorView
import Firebase
import FirebaseDatabase
import FirebaseStorage
import CoreLocation
import QuiltView
import Hero
import Device
import Instructions

//ISSUE: WHEN LOADING COVER IMAGES, THE NUMBER OF THEM IS LOADED, NOT IN ORDER SO THERE ARE DIPLICATES AND SOME ARE MISSING
final class SellingCollectionViewController: ImageCollectionViewController {

    var user: User?

    var shouldRefresh = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldRefresh {
            self.refresher.beginRefreshing()
            refresh()
        }
        shouldRefresh = true

    }
    
    override func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int{
        return 0
    }
    override func loadCoverImages() {

        var ref: FIRDatabaseReference
        if let user = user, let uid = user.uid {
            ref = FIRDatabase.database().reference().child(currentGroup).child("users").child(uid).child("coverImages")
        } else { ref = FIRDatabase.database().reference().child(currentGroup).child("users").child((currentUser.uid)!).child("coverImages")}
        let storage = FIRStorage.storage()
        ref.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var i = 0
                for snapshot in snapshots {
                    if let path = snapshot.value as? String {
                        let coverImagePath = storage.reference(forURL: path)
                        coverImagePath.data(withMaxSize: 1 * 1_024 * 1_024) { data, error in
                            if let error = error {
                                //Might want to add this back but gets error when making item
                                //                                ErrorGenerator.presentError(view: self, type: "Cover Images", error: error)
                            } else {
                                let image = UIImage(data: data!)
                                self.coverImages.append(image!)
                                if let extractedKey: String?=path.substring(start: 44, end: 64) {
                                    self.itemKeys.append(extractedKey!)
                                    self.coverImageKeys.append((snapshot.key as? String)!)
                                }
                                i += 1
                                if i == snapshots.count {
                                    self.originalImages=self.coverImages
                                    self.activityIndicator?.stopAnimating()
                                    self.refresher.endRefreshing()
                                    self.loadingImages=false
                                    self.filterItems(category: (self.filterButton.titleLabel?.text)!)
                                }
                            }
                        }

                    }
                }
                if snapshots.count == 0 {
                    self.activityIndicator?.stopAnimating()
                    self.refresher.endRefreshing()
                    self.loadingImages=false
                    self.collectionView?.reloadData()
                }

            }

        })
    }

}
