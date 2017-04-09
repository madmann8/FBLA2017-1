//
//  SelectPhotosToUploadCollectionViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/8/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import Foundation
import UIKit


class SelectPhotosToUploadCollectionViewController:UICollectionViewController{
    fileprivate let reuseIdentifier = "UploadCell"

    override func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! UploadItemFormPhotoCellCollectionViewCell
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
}
