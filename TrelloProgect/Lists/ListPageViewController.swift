//
//  ListPageViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/29/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class ListPageViewController: UIPageViewController {
  
  var pageControl = UIPageControl()
  var idOfboard : String?
  var colorOfBoard : UIColor?
  var listViewModel = ListViewModel()
  
  var controllers : [UIViewController]?
 
  
  lazy var orderedViewControllers: [UIViewController] = {
    
    var controllers =  [UIViewController]()
    if let countOfControllers = listViewModel.lists?.numberOfSections(){
      for i in 0...countOfControllers + 1{
        guard let  viewController = newVc(viewController: "ListViewController") as? ListViewController
          else {return [UIViewController()]}
        viewController.colorOfBoard  = colorOfBoard
        let list = listViewModel.lists?.item(at: (IndexPath(row: i, section: 0)))
        if let listOfBoard = list as? ListOfBoard{
          viewController.listOfBoard  = listOfBoard
        }
        controllers.append(newVc(viewController: "ListViewController"))
      }
      return controllers
    }
    return [self.newVc(viewController: "ListViewController")]
  }()
  
  override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  }
  
  convenience init(idOfboard : String, colorOfBoard : UIColor){
    self.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    self.idOfboard = idOfboard
    self.colorOfBoard = colorOfBoard
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.listViewModel.getListFromBoadr(idOfboard!) { (result) in
      
    }
    dataSource = self
    delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let firstViewController = orderedViewControllers.first else {return}
    setViewControllers([firstViewController],direction: .forward,animated: true,completion: nil)
    configurePageControl()
  }
  
  func configurePageControl() {
    // The total number of pages that are available is based on how many available colors we have.
    pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
    self.pageControl.numberOfPages = orderedViewControllers.count
    self.pageControl.currentPage = 0
    self.pageControl.tintColor = UIColor.black
    self.pageControl.pageIndicatorTintColor = UIColor.white
    self.pageControl.currentPageIndicatorTintColor = UIColor.black
    self.view.addSubview(pageControl)
  }
  
  func newVc(viewController: String) -> UIViewController {
    return UIStoryboard(name: "Boards", bundle: nil).instantiateViewController(withIdentifier: viewController)
  }
}

extension ListPageViewController  : UIPageViewControllerDataSource{
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewController = viewController as? ListViewController else {return nil}
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {return nil}
    if viewControllerIndex ==  orderedViewControllers.count - 1{
      return nil
    }
    return orderedViewControllers[viewControllerIndex + 1]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewController = viewController as? ListViewController else {return nil}
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {return nil}
    if viewControllerIndex > 0{
      return orderedViewControllers[viewControllerIndex - 1]
    }
    return nil
  }
}

extension ListPageViewController : UIPageViewControllerDelegate {
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    let pageContentViewController = pageViewController.viewControllers![0]
    self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
  }
}
