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

class ListViewModel {
  
  let api: UsingListsOfBoard
  var lists : ArrayDataSource?
  
  init(api: UsingListsOfBoard = ServerManager.default) {
    self.api = api
  }
  
  func getListFromBoadr(_ idOfBoard: String,completion : @escaping (Error?) -> Void)  {
    api.getListsForBoard(idOfBoard) { [weak self](response) in
      var listsOfBoard = [ListOfBoard]()
      guard let arraOfList = JSON(response?.data).array else {return}
      for list in arraOfList{
        guard let listId = list["id"].string , let nameList = list["name"].string else {return}
        let list = ListOfBoard(id: listId, name: nameList)
        listsOfBoard.append(list)
      }
      self?.lists = ArrayDataSource(with: listsOfBoard)
      completion(nil)
    }
  }
  
  func  postNewCardWithName(_ name : String, completion : (Error?)-> Void) {
    
  }
  
}
