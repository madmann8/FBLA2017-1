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

final class SellingCollectionViewController: ImageCollectionViewController {

    var user: User?

    //Used to prevent contradiciting refresh/load image calls
    var shouldRefresh = false

    var frameToLoad: CGRect?

    override func viewDidLoad() {
        self.collectionView?.autoresizingMask = UIViewAutoresizing.flexibleHeight
        self.view.frame = CGRect(x: 0, y: 0, width: (frameToLoad?.width)!, height: (frameToLoad?.height)!)
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

    //This is added in order to prevent Walkthrough View from existing on this subclass
    override func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 0
    }

    //Overrided inorder to change cover images source and disable filter feature of superclass
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
                            if error != nil {
                                //Might want to add this back but gets error when making item
//                             ErrorGenerator.presentError(view: self, type: "Cover Images", error: error!)
                            } else {
                                let image = UIImage(data: data!)
                                self.coverImages.append(image!)
                                if let extractedKey: String = path.substring(start: 44, end: 64) {
                                    self.itemKeys.append(extractedKey)
                                    self.coverImageKeys.append((snapshot.key as? String)!)
                                }
                                i += 1
                                if i == snapshots.count {
                                    self.originalImages = self.coverImages
                                    self.activityIndicator?.stopAnimating()
                                    self.refresher.endRefreshing()
                                    self.loadingImages = false
                                    self.filterItems(category: ("Any"))
                                }
                            }
                        }

                    }
                }
                if snapshots.count == 0 {
                    self.activityIndicator?.stopAnimating()
                    self.refresher.endRefreshing()
                    self.loadingImages = false
                    self.collectionView?.reloadData()
                }

            }

        })
    }

}
