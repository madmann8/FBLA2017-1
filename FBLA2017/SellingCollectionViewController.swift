 import UIKit
 import NVActivityIndicatorView
 import Firebase
 import FirebaseDatabase
 import FirebaseStorage
 
 //On the next episode: well fugure out how to  reload view without using the text bar
 
 final class SellingCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "ItemCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    var coverImages = [UIImage]()
    var itemKeys=[String]()
    fileprivate let itemsPerRow: CGFloat = 3
    
    var nextItemDelegate:NextItemDelegate?=nil
    
    override func viewDidLoad() {
        currentView=self.view
        loadCoverImages()
    }
    
    var itemIndex = 0
    
    var currentView:UIView? = nil
    var currentVC:UIViewController? = nil
    
    
 }
 
 // MARK: - Private
 
 
 extension SellingCollectionViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        //                      self.collectionView?.reloadData()
        
        //        textField.text = nil
        //        textField.resignFirstResponder()
        return true
    }
 }
 
 // MARK: - UICollectionViewDataSource
 extension SellingCollectionViewController {
    
    
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
 
 extension SellingCollectionViewController : UICollectionViewDelegateFlowLayout {
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
 
 
 extension SellingCollectionViewController {
    func loadCoverImages(){
        let activityIndicator=startActivityIndicator()
        
        
        
        
        let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("coverImages")
        print((FIRAuth.auth()?.currentUser?.uid)!)
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
                                if let extractedKey:String?=path.substring(start: 40, end: 60){
                                    self.itemKeys.append(extractedKey!)
                                }
                                i+=1
                                if i==snapshots.count-1{
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
 
 
 extension SellingCollectionViewController: PhotoCellDelegate {
    func buttonPressed(keyString: String) {
        generateImages(keyString: keyString)
        let index=itemKeys.index(of: keyString)
        itemIndex=index!
    }
    
    func generateImages(keyString: String){
        var activityIndicator=startActivityIndicator()
        
        
        
        var images=[UIImage]()
        var name:String?=nil
        var about:String?=nil
        var categorey:String?=nil
        var latitudeString:String?=nil
        var longitudeString:String?=nil
        var addressString:String?=nil
        var cents:Int?=nil
        var condition:Int?=nil
        
        
        
        
        let ref = FIRDatabase.database().reference().child("items").child(keyString)
        
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
                                    
                                    
                                    
                                    
                                    activityIndicator.stopAnimating()
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    
                                    
                                    let middle=storyboard.instantiateViewController(withIdentifier: "pulley") as! FirstContainerViewController
                                    middle.categorey=categorey
                                    middle.name=name
                                    middle.about=about
                                    middle.latitudeString=latitudeString
                                    middle.longitudeString=longitudeString
                                    middle.addressString=addressString
                                    middle.cents=cents
                                    middle.condition=condition
                                    middle.images=images
                                    middle.keyString=keyString
                                    middle.nextItemDelegate=self
                                    middle.dismissDelegate=self
                                    
                                    
                                    
                                    if let vc=self.currentVC{
                                        vc.dismiss(animated: false, completion: nil)
                                    }
                                    self.currentView = middle.view
                                    self.currentVC=middle
                                    self.present(middle, animated: false, completion: nil)
                                    
                                    
                                    
                                    
                                }
                            }
                        }
                        
                    }
                }
            }
            
        })
    }
 }
 
 
 extension SellingCollectionViewController{
    func startActivityIndicator()-> NVActivityIndicatorView{
        let cellWidth = Int(self.view.frame.width / CGFloat(4))
        let cellHeight = Int(self.view.frame.height / CGFloat(8))
        let x=Int(self.view.frame.width/2)-cellWidth/2
        let y=Int(self.view.frame.height/2)-cellWidth/2
        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        let activityIndicator=NVActivityIndicatorView(frame: frame, type: .semiCircleSpin, color: UIColor.red, padding: nil)
        activityIndicator.startAnimating()
        currentView?.addSubview(activityIndicator)
        return activityIndicator
    }
 }
 
 
 extension SellingCollectionViewController:NextItemDelegate,DismissDelgate{
    func goToNextItem() {
        if itemIndex+1<itemKeys.count{
            itemIndex+=1
            generateImages(keyString: itemKeys[itemIndex])
        }
        else {
            itemIndex=0
            generateImages(keyString: itemKeys[itemIndex])
            itemIndex+=1
        }
    }
    
    func switchCurrentVC() {
        currentVC=nil
        currentView=self.view
    }
 }
 
 