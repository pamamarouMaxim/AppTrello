//
//  ListPageViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/29/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit
import CoreData

class ListPageViewController: UIPageViewController, NSFetchedResultsControllerDelegate {
  
  var pageControl = UIPageControl()
  var listPageViewModel : ListPageViewModel?
  var controllers : [UIViewController]?
  
  let coreDataManager = CoreDataManager()
  lazy var persistentContainer = coreDataManager.persistentContainer
  
  fileprivate lazy var fetchedResultsController: NSFetchedResultsController<ListEntity> = {
    let fetchRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
    let predicate = NSPredicate(format: "parentBoard.id == %@", (listPageViewModel?.rootBoard.id)!)
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataManager.readContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    return fetchedResultsController
  }()
  
  
  var addListController: AddNewListViewController? {
    guard let controller = UIStoryboard.init(name: "List", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewListViewController") as? AddNewListViewController else { return nil }
    if let rootBoard = listPageViewModel?.rootBoard{
      controller.addListViewModel = AddListViewModel(rootBoard: rootBoard)
      controller.view.backgroundColor = listPageViewModel?.rootBoard.backgroundColor
    }
    controller.onListAdded = { [weak self] list in
      do {
        try self?.fetchedResultsController.performFetch()
      } catch {
      }
      guard let listController = UIStoryboard(name: "List", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListCardsViewController") as? ListCardsViewController else {return}
      listController.listCardsViewModel = ListCardsViewModel(bordList:list)
      listController.view.backgroundColor = self?.listPageViewModel?.rootBoard.backgroundColor
      var control = self?.controllers
      guard  let countOfControllers =  self?.controllers?.count else {return}
      control?.insert(listController, at: countOfControllers - 1)
      self?.controllers = control
      self?.setViewControllers([listController], direction: .forward, animated: true)
      self?.listPageViewModel?.listsDataSource?.objects.append(list)
      guard let count = self?.fetchedResultsController.fetchedObjects?.count else {return}
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
      if let error = error{
        let alert = UIAlertController.alertWithError(error)
        self?.present(alert,animated : true)
      }
       self?.loadViewControllers()
    })
  }

  private func loadViewControllers(){
    controllers = []
    executeFetchRequest()
    guard let count = fetchedResultsController.fetchedObjects?.count else {return}
    if count > 0{
      if let firstController = createListCardViewController(indexPath: IndexPath(row: 0, section: 0)) as? ListCardsViewController{
        controllers?.append(firstController)
        if let first = controllers?.first{
          setViewControllers([first], direction: .forward, animated: true, completion: { (bool) in })
        }
      }
    } else {
      guard let addNewListController = addListController else {return}
      setViewControllers([addNewListController], direction: .forward, animated: true, completion: { (bool) in })
    }
    configurePageControl()
  }
  
  @objc func goToRoot(_ sender : UIBarButtonItem){
    let navigationController = UIStoryboard(name: "Boards", bundle: Bundle.main).instantiateViewController(withIdentifier: "AfterNavigationController") as? UINavigationController
    if let controller = navigationController {
      guard let window = UIApplication.shared.windows.first else  {return}
      let transition = CATransition()
      transition.duration = 0.5
      transition.type = kCATransitionPush
      transition.subtype = kCATransitionFromLeft
      transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
      window.layer.add(transition, forKey: kCATransition)
      present(controller, animated: false, completion: nil)
    }
  }
  
  private func createListCardViewController(indexPath : IndexPath) -> UIViewController{
    let controller = UIStoryboard(name: "List", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListCardsViewController") as? ListCardsViewController
    let listEntity = fetchedResultsController.object(at: indexPath) 
    guard let id = listEntity.id,let name = listEntity.name else {return UIViewController()}
    let listOfBoard = BoardList(id: id, name: name)
    guard  let listCardsViewController = controller else {return UIViewController()}
    listCardsViewController.listCardsViewModel = ListCardsViewModel(bordList: listOfBoard)
    listCardsViewController.view.backgroundColor = listPageViewModel?.rootBoard.backgroundColor
    return listCardsViewController
  }
  
  private func configurePageControl() {
    pageControl.removeFromSuperview()
    pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
    pageControl.currentPage = 0
    guard let count = fetchedResultsController.fetchedObjects?.count else {return}
    pageControl.numberOfPages = count + 1
    pageControl.tintColor = UIColor.black
    pageControl.pageIndicatorTintColor = UIColor.white
    pageControl.currentPageIndicatorTintColor = UIColor.black
    view.addSubview(pageControl)
  }
  
  private func executeFetchRequest(){
    do {
      try fetchedResultsController.performFetch()
    } catch (let error){
      let alert = UIAlertController.alertWithError(error)
      self.present(alert, animated: true)
    }
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
    guard let numberOfItems = fetchedResultsController.fetchedObjects?.count else {return nil}
    
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
