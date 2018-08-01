//
//  Rabish.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/2/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

//import Foundation
//func loadLists() {
//  getListFromBoadr(){ [weak self](result) in
//    var controllers = [UIViewController]()
//    let  firstEndViewController = UIViewController()
//    firstEndViewController.view.backgroundColor = self?.rootBoard.backgroundColor
//    controllers.append(firstEndViewController)
//    guard let listsCount = self?.listsDataSource?.numberOfItems(in: 0) else {return}
//    for numberOfList in 0..<listsCount{
//      let indexPath = IndexPath(row: numberOfList, section: 0)
//      guard let controller = self?.listViewController(indexPath: indexPath) else {return}
//      controllers.append(controller)
//    }
//    guard let addNewListController = self?.addNewListViewController() else {return}
//    controllers.append(addNewListController)
//    controllers.append(firstEndViewController)
//    
//    self?.controllers = controllers
//  }
//}
//
//private func addNewListViewController() -> UIViewController {
//  let controller = UIStoryboard.init(name: "Boards", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewListViewController") as? AddNewListViewController
//  guard  let addNewListViewController = controller else {return UIViewController()}
//  let addListViewModel = AddListViewModel(api: ServerManager.default, rootBoard: rootBoard)
//  addNewListViewController.addListViewModel = addListViewModel
//  addNewListViewController.view.backgroundColor = rootBoard.backgroundColor
//  return  addNewListViewController
//}
//
//private func listViewController(indexPath : IndexPath) -> UIViewController {
//  let controller = UIStoryboard(name: "Boards", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListCardsViewController") as? ListCardsViewController
//  guard  let listCardsViewController = controller else {return UIViewController()}
//  guard let listOfBoard = listsDataSource?.item(at: indexPath) as? BoardList else {return UIViewController()}
//  listCardsViewController.listCardsViewModel = ListCardsViewModel(bordList: listOfBoard)
//  listCardsViewController.view.backgroundColor = rootBoard.backgroundColor
//  return  listCardsViewController
//}

