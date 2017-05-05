//
//  PageViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/12/17.
//  Copyright Â© 2017 Luke Mann. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    var images: [UIImage]?

    var lastPendingViewControllerIndex = 0
    var currentPageIndex = 0
    var index = 0

    lazy var orderedViewControllers: [UIViewController] = []

    var nextItemDelegate: NextItemDelegate?

    override func viewDidLoad() {
        self.gestureRecognizers.first?.cancelsTouchesInView = true
        self.dataSource = self
        if !(images?.isEmpty)! {
            for image in images! {
                makeAndAppeadVC(image: image)
            }
        }
        setViewControllers([orderedViewControllers.first!], direction: .forward, animated: true, completion: nil)
    }

    func makeAndAppeadVC(image: UIImage) {
        var pageStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var VC: ImageViewController = pageStoryboard.instantiateViewController(withIdentifier: "sbImage") as! ImageViewController
        VC.image = image
        VC.nextItemDelegate = self
        orderedViewControllers.append(VC)
    }

}

extension PageViewController: UIPageViewControllerDataSource {

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

extension PageViewController:NextItemDelegate {
    func goToNextItem() {
        self.nextItemDelegate?.goToNextItem()
    }
}
