//
//  File.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/1/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class AddListViewModel {
  
  let api: UsingListsOfBoard
  var rootBoard : Board
  var boardsDataSource : ArrayDataSource?
  
  init(api: UsingListsOfBoard = ServerManager.default,rootBoard : Board) {
    self.api = api
    self.rootBoard = rootBoard
    
  }
  
  func postListName(_ name:String, completion : @escaping (BoardList?)-> Void) {
    
    api.makeNewListInBoard(rootBoard.id, nameList: name) { (result) in
      switch result {
      case .success(let success) : let data = JSON(success)
        guard let listId = data["id"].string else {return}
        guard let listName = data["name"].string else {return}
        let list = BoardList(id: listId, name: listName)
        completion(list)
      case .failure(let error): completion(nil)
      }
    }
  }
}
