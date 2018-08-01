//
//  ListViewModel.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/29/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ListPageViewModel {
  
  let api: UsingListsOfBoard = ServerManager.default
  var rootBoard : Board!
  var listsDataSource : ArrayDataSource?
  var controllers : [UIViewController]?
  
  init(rootBoard : Board) {
    self.rootBoard = rootBoard
  }
  
  func getListFromBoadr(completion : @escaping (Error?) -> Void)  {
    api.getListsForBoard(rootBoard.id) { [weak self](response) in
      var listsOfBoard = [BoardList]()
      guard let arraOfList = JSON(response?.result.value).array else {return}
      for list in arraOfList{
        guard let listId = list["id"].string , let nameList = list["name"].string else {return}
        let list = BoardList(id: listId, name: nameList)
        listsOfBoard.append(list)
      }
      self?.listsDataSource = ArrayDataSource(with: listsOfBoard)
      completion(nil)
    }
  }
  
}
