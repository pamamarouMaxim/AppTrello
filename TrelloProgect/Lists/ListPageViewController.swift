//
//  ListPageViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/29/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class ListPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  
  var pageControl = UIPageControl()
  var listPageViewModel : ListPageViewModel?
  var controllers : [UIViewController]?
  var controller : UIViewController!
  
  // MARK: UIPageViewControllerDataSource
  
  override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  }
  
  convenience init(listPageViewModel : ListPageViewModel ){
    self.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    self.listPageViewModel = listPageViewModel
    NotificationCenter.default.addObserver(self, selector: #selector(ListPageViewController.addedNewList(notification:)), name: .AddedNewListOnBoard, object: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataSource = self
    delegate = self
    loadLists()
  }
  
  @objc func addedNewList(notification: Notification){
    
    guard let listViewController = notification.object as? ListCardsViewController else {return}
    var control =  controllers
    control?.insert(listViewController, at: (controllers?.count)! - 1)
    controllers = control
    let first = controllers?.first!
    setViewControllers([listViewController], direction: .forward, animated: true)
    configurePageControl()
  }
  
  
  func configurePageControl() {
    pageControl.removeFromSuperview()
    pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
    if let count =  controllers?.count{
      self.pageControl.numberOfPages = count
      //pageControl.currentPage = 0
      pageControl.tintColor = UIColor.black
      pageControl.pageIndicatorTintColor = UIColor.white
      pageControl.currentPageIndicatorTintColor = UIColor.black
      view.addSubview(pageControl)
    }
  }
  
  // MARK: Delegate methords
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
      
      let pageContentViewController = pageViewController.viewControllers![0]
      self.pageControl.currentPage = (controllers?.index(of: pageContentViewController)!)!
      
    }
  
  // MARK: Data source functions.
  
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
      guard let viewControllers  = controllers else {return nil}
      guard let viewControllerIndex = viewControllers.index(of: viewController) else {return nil}
      if viewControllerIndex > 0{
        return viewControllers[viewControllerIndex - 1]
      }
      return nil
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllers  = controllers else {return nil}
    guard let viewControllerIndex = viewControllers.index(of: viewController) else {return nil}
    if viewControllerIndex == viewControllers.count - 1{
      return nil
    }
    return viewControllers[viewControllerIndex + 1]
  }

  private func loadLists(){
    guard let listPageViewModel = listPageViewModel else {return}
    listPageViewModel.getListFromBoadr(){ [weak self](result) in
      var controllers = [UIViewController]()
      let  firstEndViewController = UIViewController()
      firstEndViewController.view.backgroundColor = listPageViewModel.rootBoard.backgroundColor
     // controllers.append(firstEndViewController)
      let count : Int = (self?.listPageViewModel?.listsDataSource?.numberOfItems(in: 0))!
      for numberOfList in 0..<count{
        let indexPath = IndexPath(row: numberOfList, section: 0)
        guard let controller = self?.listViewController(indexPath: indexPath) else {return}
        controllers.append(controller)
      }
      guard let addNewListController = self?.addNewVistViewController() else {return}
      controllers.append(addNewListController)
      //controllers.append(firstEndViewController)
      self?.controllers = controllers
      let first = self?.controllers?.first!
      self?.setViewControllers([first!], direction: .forward, animated: true)
      self?.configurePageControl()
    }
  }
  
  private func addNewVistViewController() -> UIViewController {
    
    let controller = UIStoryboard.init(name: "Boards", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewListViewController") as? AddNewListViewController
    guard  let addNewVistViewController = controller else {return UIViewController()}
    guard let listPageViewModel = listPageViewModel else {return UIViewController()}
    addNewVistViewController.addListViewModel = AddListViewModel(rootBoard: listPageViewModel.rootBoard)
    addNewVistViewController.view.backgroundColor = listPageViewModel.rootBoard.backgroundColor
    return  addNewVistViewController
  }
  
  private func listViewController(indexPath : IndexPath) -> UIViewController {
    
    let controller = UIStoryboard(name: "Boards", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListCardsViewController") as? ListCardsViewController
    guard let listPageViewModel = listPageViewModel else {return UIViewController()}
    guard let listOfBoard = listPageViewModel.listsDataSource?.item(at: indexPath) as? BoardList else {return UIViewController()}
    guard  let listCardsViewController = controller else {return UIViewController()}
    listCardsViewController.listCardsViewModel = ListCardsViewModel(bordList: listOfBoard)
    listCardsViewController.view.backgroundColor = listPageViewModel.rootBoard.backgroundColor
    return  listCardsViewController
  }
}

