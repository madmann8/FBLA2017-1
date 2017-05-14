//
//  PageViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/12/17.
//  Copyright Â© 2017 Luke Mann. All rights reserved.
//

import UIKit

//This class is used to manage the image pages in the item view
class PageViewController: UIPageViewController {
    
    var images: [UIImage]?
    
    var lastPendingViewControllerIndex = 0
    var currentPageIndex = 0
    var index = 0
    
    var pageControl: UIPageControl?
    
    lazy var orderedViewControllers: [UIViewController] = []
    
    var nextItemDelegate: NextItemDelegate?
    
    override func viewDidLoad() {
        self.gestureRecognizers.first?.cancelsTouchesInView = true
        self.dataSource = self
        self.delegate = self
        if !(images?.isEmpty)! {
            for image in images! {
                makeAndAppeadVC(image: image)
            }
        }
        pageControl?.numberOfPages = orderedViewControllers.count
        
        setViewControllers([orderedViewControllers.first!], direction: .forward, animated: true, completion: nil)
    }
    
    func makeAndAppeadVC(image: UIImage) {
        let pageStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let VC: ImageViewController = pageStoryboard.instantiateViewController(withIdentifier: "sbImage") as! ImageViewController
        VC.image = image
        VC.nextItemDelegate = self
        orderedViewControllers.append(VC)
    }
    
}

// MARK: Data source
extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
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
        
                guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed && finished {
            if let currentVC = pageViewController.viewControllers?.last {
                let pos = orderedViewControllers.index(of: currentVC)
                pageControl?.currentPage = pos!
                pageControl?.numberOfPages = orderedViewControllers.count
            }
        }
    }
}

extension PageViewController:NextItemDelegate {
    func goToNextItem() {
        self.nextItemDelegate?.goToNextItem()
    }
}
