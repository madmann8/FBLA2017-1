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
    
    var coverImages = [UIImage]()
    var itemKeys=[String]()
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
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! PhotoCell
        cell.imageView.image = coverImages[indexPath.row]
        
        cell.delegate=self
        
        cell.keyString=itemKeys[indexPath.row]
        
        return cell
    }
    
}

extension ImageCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let photo = coverImages[indexPath.row]
        let height=photo.size.height
        let width=photo.size.width
        let dynamicHeightRatio=height/width
        
        return CGSize(width: widthPerItem, height: widthPerItem*dynamicHeightRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


extension ImageCollectionViewController {
    func loadCoverImages(){
        let activityIndicator=startActivityIndicator()
        
        
        
        
        let ref = FIRDatabase.database().reference().child("coverImagePaths")
        let storage = FIRStorage.storage()
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
                                let image = UIImage(data: data!)
                                self.coverImages.append(image!)
                                if let extractedKey:String?=path.substring(start: 44, end: 63){
                                    self.itemKeys.append(extractedKey!)
                                }
                                print(i)
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


extension ImageCollectionViewController: PhotoCellDelegate {
    func buttonPressed(keyString: String) {
        generateImages(keyString: keyString)
        
        
    }
    
    func generateImages(keyString: String){
        var activityIndicator=startActivityIndicator()
        
        var images=[UIImage]()
        let ref = FIRDatabase.database().reference().child("items").child(keyString).child("imagePaths")
        let storage = FIRStorage.storage()
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
                                let image = UIImage(data: data!)
                                images.append(image!)
                                print(i)
                                i+=1
                                if i==snapshots.count{
                                    activityIndicator.stopAnimating()
                                }
                            }
                        }
                        
                    }
                }
            }
            
        })
    }
}


extension ImageCollectionViewController{
    func startActivityIndicator()-> NVActivityIndicatorView{
        let cellWidth = Int(self.view.frame.width / CGFloat(4))
        let cellHeight = Int(self.view.frame.height / CGFloat(8))
        let x=Int(self.view.frame.width/2)-cellWidth/2
        let y=Int(self.view.frame.height/2)-cellWidth/2
        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        let activityIndicator=NVActivityIndicatorView(frame: frame, type: .semiCircleSpin, color: UIColor.red, padding: nil)
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        return activityIndicator
    }
}

extension String
{
    func substring(start: Int, end: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if end < 0 || end > self.characters.count
        {
            print("end index \(end) out of bounds")
            return ""
        }
        let startIndex = self.characters.index(self.startIndex, offsetBy: start)
        let endIndex = self.characters.index(self.startIndex, offsetBy: end)
        let range = startIndex..<endIndex
        
        return self.substring(with: range)
    }
}
