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
  var listPageViewModel : ListPageViewModel?
  var controllers : [UIViewController]?
  
  var addListController: AddNewListViewController? {
    guard let controller = UIStoryboard.init(name: "List", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewListViewController") as? AddNewListViewController else { return nil }
    controller.addListViewModel = AddListViewModel(rootBoard: (listPageViewModel?.rootBoard)!)
    controller.view.backgroundColor = listPageViewModel?.rootBoard.backgroundColor
    
    controller.onListAdded = { [weak self] list in
      
      guard let listController = UIStoryboard(name: "List", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListCardsViewController") as? ListCardsViewController else {return}
      listController.listCardsViewModel = ListCardsViewModel(bordList:list)
      listController.view.backgroundColor = self?.listPageViewModel?.rootBoard.backgroundColor
      var control = self?.controllers
      guard  let countOfControllers =  self?.controllers?.count else {return}
      control?.insert(listController, at: countOfControllers - 1)
      self?.controllers = control
      self?.setViewControllers([listController], direction: .forward, animated: true)
      self?.listPageViewModel?.listsDataSource?.objects.append(list)
      guard let viewModel = self?.listPageViewModel,let count = viewModel.listsDataSource?.numberOfItems(in: 0) else {return}
      self?.pageControl.numberOfPages = count + 1
      guard let currentPage = self?.controllers?.index(of: listController) else {return}
      self?.pageControl.currentPage = currentPage
    }
    
    return controller
  }
  
  override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  }
  
  convenience init(listPageViewModel : ListPageViewModel ){
    self.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    self.listPageViewModel = listPageViewModel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let backToRoot = UIBarButtonItem(barButtonSystemItem:.cancel, target: self, action: #selector(goToRoot(_:)))
    self.navigationItem.setLeftBarButtonItems([backToRoot], animated: true)
    dataSource = self
    delegate = self
    listPageViewModel?.getListsFromBoard(completion: { [weak self](error) in
      self?.controllers = [UIViewController]()
      if let firstController = self?.createListCardViewController(indexPath: IndexPath(row: 0, section: 0)){
         self?.controllers?.append(firstController)
        if let first = self?.controllers?.first{
          self?.setViewControllers([first], direction: .forward, animated: true, completion: { (bool) in })
          self?.configurePageControl()
        }
      } else {
          guard let addNewListController = self?.addListController else {return}
        self?.setViewControllers([addNewListController], direction: .forward, animated: true, completion: { (bool) in })
      }
    })
  }

  @objc func goToRoot(_ sender : UIBarButtonItem){
    let navigationController = UIStoryboard(name: "Boards", bundle: Bundle.main).instantiateViewController(withIdentifier: "AfterNavigationController") as? UINavigationController
    if let controller = navigationController {
      guard let window = UIApplication.shared.windows.first else {return}
      UIView.transition(with: window, duration: 1, options: .transitionFlipFromLeft, animations: {
        window.rootViewController = controller
      }, completion: { completed in
      })
    }
  }
  
  private func createListCardViewController(indexPath : IndexPath) -> UIViewController{
    let controller = UIStoryboard(name: "List", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListCardsViewController") as? ListCardsViewController
    guard let listOfBoard = listPageViewModel?.listsDataSource?.item(at: indexPath) as? BoardList else {return UIViewController()}
    guard  let listCardsViewController = controller else {return UIViewController()}
    listCardsViewController.listCardsViewModel = ListCardsViewModel(bordList: listOfBoard)
    listCardsViewController.view.backgroundColor = listPageViewModel?.rootBoard.backgroundColor
    return listCardsViewController
  }
  
  private func configurePageControl() {
    pageControl.removeFromSuperview()
    pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
    guard let viewModel = listPageViewModel,let count = viewModel.listsDataSource?.numberOfItems(in: 0) else {return}
    pageControl.currentPage = 0
    pageControl.numberOfPages = count + 1
    pageControl.tintColor = UIColor.black
    pageControl.pageIndicatorTintColor = UIColor.white
    pageControl.currentPageIndicatorTintColor = UIColor.black
    view.addSubview(pageControl)
  }
}

extension ListPageViewController : UIPageViewControllerDataSource{
  
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
    guard let numberOfItems = listPageViewModel?.listsDataSource?.numberOfItems(in: 0) else {return nil}
    
    if viewControllerIndex == viewControllers.count - 1{
      if viewControllers.count == numberOfItems{
        guard let addListViewController = addListController else {return nil}
        controllers?.append(addListViewController)
       return addListViewController
      } else if viewControllers.count  == numberOfItems + 1{
        return nil
      } else {
        let listCardViewController = createListCardViewController(indexPath: IndexPath(row: viewControllerIndex + 1, section: 0))
        self.controllers?.append(listCardViewController)
        return listCardViewController
      }
    }
    return viewControllers[viewControllerIndex + 1]
  }
}

extension ListPageViewController : UIPageViewControllerDelegate{
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard let pageControllers = pageViewController.viewControllers else {return}
    let first = pageControllers[0]
    guard let currentPage = controllers?.index(of: first) else {return}
    pageControl.currentPage = currentPage
  }
}
