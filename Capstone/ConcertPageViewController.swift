//
//  ConcertPageViewController.swift
//  Capstone
//
//  Created by Martin Kirke on 12/8/16.
//  Copyright © 2016 Ghost. All rights reserved.
//

import UIKit

class ConcertPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let page1 = storyboard.instantiateViewController(withIdentifier: "SearchResultsView")
 //       let page2 = storyboard.instantiateViewController(withIdentifier: "MapViewController")
        let page3 = storyboard.instantiateViewController(withIdentifier: "SavedView")
        
        pages.append(page1)
//        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([pages.first!], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
//        func removeSwipeGesture(){
//            for view in ConcertPageViewController {
//                if let subView = view as? UIScrollView {
//                    subView.isScrollEnabled = false
//                }
//            }
//        }
        
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
    
    private func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    private func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
