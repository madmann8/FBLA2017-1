//
//  PageViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/12/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var images:[UIImage]?=nil
    
    var keyString:String?=nil
    
    lazy var orderedViewControllers:[UIViewController] = []
    
    
    
    override func viewDidLoad() {
        self.dataSource=self
//        var pageStoryboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
//        var VC:ImageAndButtonsViewController=pageStoryboard.instantiateViewController(withIdentifier: "sbImageMain") as! ImageAndButtonsViewController
//        if let image=images?[0]{
//            VC.image=image
//            self.images?.remove(at: 0)
//            orderedViewControllers.append(VC)
//        }
        if !(images?.isEmpty)!{
        for image in images!{
            makeAndAppeadVC(image: image)
        }
        }
        setViewControllers([orderedViewControllers.first!], direction: .forward, animated: true, completion: nil)
    }
    
    func makeAndAppeadVC(image:UIImage){
        var pageStoryboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
        var VC:ImageViewController=pageStoryboard.instantiateViewController(withIdentifier: "sbImage") as! ImageViewController
        VC.image=image
        orderedViewControllers.append(VC)
    }
    
    
}

extension PageViewController: UIPageViewControllerDataSource{
    
    
    
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}


