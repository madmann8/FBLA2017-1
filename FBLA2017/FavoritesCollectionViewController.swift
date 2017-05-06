import UIKit
import NVActivityIndicatorView
import Firebase
import FirebaseDatabase
import FirebaseStorage
import CoreLocation
import QuiltView
import Hero
import Device

//ISSUE: WHEN LOADING COVER IMAGES, THE NUMBER OF THEM IS LOADED, NOT IN ORDER SO THERE ARE DIPLICATES AND SOME ARE MISSING
final class FavoritesCollectionViewController: ImageCollectionViewController {
    
      var user: User?
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator = ActivityIndicatorLoader.startActivityIndicator(view: self.view)
        currentView = self.view
        loadCoverImages()

    }
    
    override func loadCoverImages() {
        
        var ref: FIRDatabaseReference
        if let user = user, let uid = user.uid {
            ref = FIRDatabase.database().reference().child("users").child(uid).child("likedCoverImages")
        } else { ref = FIRDatabase.database().reference().child("users").child((currentUser.uid)!).child("likedCoverImages")}
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
                                    self.activityIndicator?.stopAnimating()
                                    self.refresher.endRefreshing()
                                    self.collectionView?.reloadData()
                                }
                            }
                        }
                        
                    }
                }
            }
            
        })
    }
}
