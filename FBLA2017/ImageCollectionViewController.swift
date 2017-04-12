import UIKit
import NVActivityIndicatorView
import Firebase
import FirebaseDatabase
import FirebaseStorage

//On the next episode: well fugure out how to  reload view without using the text bar


final class ImageCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "ItemCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    fileprivate var searches = [FlickrSearchResults]()
    var coverImages = [UIImage]()
    fileprivate let flickr = Flickr()
    fileprivate let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        loadCoverImages()
    }
}

// MARK: - Private


extension ImageCollectionViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        
//                      self.collectionView?.reloadData()
 
//        textField.text = nil
//        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension ImageCollectionViewController {

    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return coverImages.count
    }
    
    //3
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! PhotoCell
        //2
//        let flickrPhoto = self.photoForIndexPath(indexPath)
//        cell.backgroundColor = UIColor.white
        //3
        cell.imageView.image = coverImages[indexPath.row]
        
        return cell
    }
}

extension ImageCollectionViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let photo = coverImages[indexPath.row]
        let height=photo.size.height
        let width=photo.size.width
        let dynamicHeightRatio=height/width
        
        return CGSize(width: widthPerItem, height: widthPerItem*dynamicHeightRatio)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


extension ImageCollectionViewController {
    func loadCoverImages(){
        let cellWidth = Int(self.view.frame.width / CGFloat(4))
        let cellHeight = Int(self.view.frame.height / CGFloat(8))
        let x=Int(self.view.frame.width/2)-cellWidth/2
        let y=Int(self.view.frame.height/2)-cellWidth/2
        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        let activityIndicator=NVActivityIndicatorView(frame: frame, type: .pacman, color: UIColor.red, padding: nil)
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        
        
        
        var ref = FIRDatabase.database().reference().child("coverImagePaths")
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        ref.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var i=0
                for snapshot in snapshots {
                    if let path = snapshot.value as? String {
                        let coverImagePath = storage.reference(forURL: path)
                        coverImagePath.data(withMaxSize: 1 * 1024 * 1024) { data, error in
                            if let error = error {
                                // Uh-oh, an error occurred!
                            } else {
                                // Data for "images/island.jpg" is returned
                                let image = UIImage(data: data!)
                                self.coverImages.append(image!)
                                i+=1
                                if i==snapshots.count{
                                    activityIndicator.stopAnimating()
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
