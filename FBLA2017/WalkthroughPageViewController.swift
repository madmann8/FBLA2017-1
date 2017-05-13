//
//  WalkthroughPageViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 5/7/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit

protocol PageControlDelegate {
    func update(count: Int, index: Int)
}

//Class to mange the walkthough pages
class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    
    var pageControlDelegate: PageControlDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        for i in 1 ... 12 {
            let page: WalkthroughSinglePageViewController = storyboard.instantiateViewController(withIdentifier: "walkthrough") as! WalkthroughSinglePageViewController
            page.index = i
            pages.append(page)
            
        }
        
        setViewControllers([pages[0]], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        pageControlDelegate?.update(count: pages.count, index: 0)
        
    }
    
    func getRandomColor() -> UIColor {
        
        let randomRed: CGFloat = CGFloat(drand48())
        let randomGreen: CGFloat = CGFloat(drand48())
        let randomBlue: CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = pages.index(of: viewController)!
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed && finished {
            if let currentVC = pageViewController.viewControllers?.last {
                let pos = pages.index(of: currentVC)
                pageControlDelegate?.update(count: pages.count, index: pos!)
            }
        }
    }
    
    
}
