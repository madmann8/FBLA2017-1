import UIKit
 import NVActivityIndicatorView
 import Firebase
 import FirebaseDatabase
 import FirebaseStorage
 import CoreLocation
 import QuiltView
 import Hero
 import Device

  class ImageCollectionViewController: UICollectionViewController {

    // MARK: - Properties
    fileprivate let reuseIdentifier = "ItemCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 2, left: 2, bottom: 5, right: 2)

    private typealias imageAndIndex = (Int, UIImage)
    var coverImages = [UIImage]()
    var itemKeys=[String]()
    var coverImageKeys=[String]()
    fileprivate let itemsPerRow: CGFloat = 3

    var nextItemDelegate: NextItemDelegate?

    var refresher = UIRefreshControl()

    var activityIndicator: NVActivityIndicatorView?

    var readyToLoad = true

    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser.loadGroup()

        activityIndicator = ActivityIndicatorLoader.startActivityIndicator(view: self.view)

        self.refresher.addTarget(self, action: #selector(ImageCollectionViewController.refresh), for: .valueChanged)

        self.collectionView?.refreshControl = refresher

        currentView = self.view
        let layout = self.collectionView?.collectionViewLayout as! QuiltView
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        switch Device.size() {
        case .screen4_7Inch:layout.itemBlockSize = CGSize(width: 62, height: 62)
        case .screen5_5Inch: layout.itemBlockSize = CGSize(width: 67, height: 67)
        default: layout.itemBlockSize = CGSize(width: 67, height: 67)

        }
        
        currentUser.setupUser(id: (FIRAuth.auth()?.currentUser?.uid)!, isLoggedIn: true)
        loadCoverImages()

    }

   
    var itemIndex = 0

    var currentView: UIView?
    var currentVC: UIViewController?
    var firstDetailVC: UIViewController?

 }

 // MARK: - Private

 extension ImageCollectionViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
 }

 // MARK: - UICollectionViewDataSource
 extension ImageCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return coverImages.count
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return coverImages.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! PhotoCell
        cell.imageView.image = coverImages[indexPath.row]

        cell.delegate = self

        cell.keyString = itemKeys[indexPath.row]

        cell.coverImageKeyString = coverImageKeys[indexPath.row]

        return cell
    }

    func refresh() {
        self.collectionView?.reloadData()
        itemIndex=0
        activityIndicator = nil
        coverImages.removeAll()
        itemKeys.removeAll()
        coverImageKeys.removeAll()
        currentView = nil
        firstDetailVC = nil
        loadCoverImages()
    }

 }

 extension ImageCollectionViewController : QuiltViewDelegate {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, blockSizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let photo = coverImages[indexPath.row]
        let height = photo.size.height
        let width = photo.size.width
        let dynamicHeightRatio = height / width

        print(widthPerItem * dynamicHeightRatio)
        return CGSize(width: 2, height: 2 * dynamicHeightRatio)
        //        return CGSizeMake(100, 100)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForItemAtIndexPath indexPath: IndexPath) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return sectionInsets.left
    //    }
 }

 extension ImageCollectionViewController {
    func loadCoverImages() {
let group=currentGroup
        let ref = FIRDatabase.database().reference().child(currentGroup).child("coverImagePaths")
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

 extension ImageCollectionViewController: PhotoCellDelegate {
    func buttonPressed(keyString: String, coverImageKeyString: String ) {
        if readyToLoad {
            readyToLoad = false
        generateImages(keyString: keyString, inImageView: false, coverImageKey: coverImageKeyString)
        let index = itemKeys.index(of: keyString)
        itemIndex = index!
        }
    }

    func generateImages(keyString: String, inImageView: Bool, coverImageKey: String) {
        let activityIndicator:NVActivityIndicatorView
        if (self.currentView != nil)  {
         activityIndicator = ActivityIndicatorLoader.startActivityIndicator(view: self.currentView!)
        }
        else {
            activityIndicator = ActivityIndicatorLoader.startActivityIndicator(view: self.view)
        }

        var name: String?=nil
        var about: String?=nil
        var categorey: String?=nil
        var latitudeString: String?=nil
        var longitudeString: String?=nil
        var addressString: String?=nil
        var cents: Int?=nil
        var condition: Int?=nil
        var userID: String?=nil

        let ref = FIRDatabase.database().reference().child(currentGroup).child("items").child(keyString)
        let user = User()
        let item=Item()

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
            userID = value?["userID"] as? String ?? ""
            user.setupUser(id: userID!, isLoggedIn: false)

        })
        let storage = FIRStorage.storage()
        let middle = storyboard?.instantiateViewController(withIdentifier: "pulley") as! FirstContainerViewController
        user.delegate = middle
        ref.child("imagePaths").observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var i = 0
                var images=[UIImage?]()

                for snapshot in snapshots {
                    images.append(nil)
                    if let path = snapshot.value as? String {
                        let imagePath = storage.reference(forURL: path)
                        imagePath.data(withMaxSize: 1 * 6_000 * 6_000) { data, error in
                            if let error = error {
                                ErrorGenerator.presentError(view: self, type: "Item Images", error: error)
                            } else {
                                let image = UIImage(data: data!)
                                images[Int(snapshot.key)!] = image
                                print(i)
                                i += 1
                                if i == snapshots.count {

                                    activityIndicator.stopAnimating()

                                    item.categorey=categorey
                                    item.name=name
                                    item.about=about
                                    item.latitudeString=latitudeString
                                    item.longitudeString=longitudeString
                                    item.addressString=addressString
                                    item.cents=cents
                                    item.condition=condition
                                    item.images=images as? [UIImage]
                                    item.keyString=keyString
                                    item.coverImagePath=path
                                    item.user=user
                                    middle.nextItemDelegate = self
                                    middle.dismissDelegate = self
                                    user.delegate = middle
                                    middle.item=item

                                    
                                    
                                    FIRDatabase.database().reference().child(currentGroup).child("coverImagePaths").child(coverImageKey).observe(.value, with: { (snapshot) in

                                                if let path = snapshot.value as? String {
                                                    item.coverImagePath = path
                                                    if inImageView {
                                                        if let vc = self.currentVC as? FirstContainerViewController {
                                                            vc.present(middle, animated: true)
                                                            middle.vcToDismiss = vc
                                                        }

                                                    } else {
                                                        self.present(middle, animated: true, completion: nil)
                                                        self.firstDetailVC = middle
                                                    }

                                                    self.currentView = middle.view
                                                    self.currentVC = middle

                                                }

                                    })
                                    self.readyToLoad = true
                                }
                            }
                        }

                    }
                }
            }

        })
        let ref2 = FIRDatabase.database().reference().child(currentGroup).child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("likedCoverImages")
        ref2.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var i = 0
                for snapshot in snapshots {
                    if let path = snapshot.key as? String {
                        print("Local path\(keyString)")
                        print(path)
                        if path == keyString {
                            item.hasLiked = true
                        }
                        
                    }
                }
            }
            
        })
    }
 }


 extension ImageCollectionViewController:NextItemDelegate, DismissDelgate {
    func goToNextItem() {
        if itemIndex + 1 < itemKeys.count {
            itemIndex += 1
            generateImages(keyString: itemKeys[itemIndex], inImageView: true, coverImageKey: coverImageKeys[itemIndex])
        } else {
            itemIndex = 0
            generateImages(keyString: itemKeys[itemIndex], inImageView: true, coverImageKey: coverImageKeys[itemIndex])
            itemIndex += 1
        }
    }

    func switchCurrentVC(shouldReload: Bool) {

        currentVC = nil
        currentView = self.view
        //TODO: Fix this
        firstDetailVC?.dismiss(animated: false, completion: nil)
        if shouldReload {
            //TODO: Might want to call viewDidLoad() here
             coverImages.removeAll()
             itemKeys.removeAll()
             coverImageKeys.removeAll()
             currentView = nil
             firstDetailVC = nil

        }
    }

 }

 extension ImageCollectionViewController:UploadFinishedDelegate {
    func reload() {
        refresh()
    }
    
 }

extension String {
    func substring(start: Int, end: Int) -> String {
        if (start < 0 || start > self.characters.count) {
            print("start index \(start) out of bounds")
            return ""
        } else if end < 0 || end > self.characters.count {
            print("end index \(end) out of bounds")
            return ""
        }
        let startIndex = self.characters.index(self.startIndex, offsetBy: start)
        let endIndex = self.characters.index(self.startIndex, offsetBy: end)
        let range = startIndex..<endIndex
        
        return self.substring(with: range)
    }}

