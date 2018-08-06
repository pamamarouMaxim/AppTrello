//
//  File.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/1/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import SwiftyJSON

class AddListViewModel {
  
  let api: UsingListsOfBoard
  var rootBoard : BoardViewModel
  
  init(api: UsingListsOfBoard = ServerManager.default,rootBoard : BoardViewModel) {
    self.api = api
    self.rootBoard = rootBoard
    
  }
  
  func   postNewListWithName(_ name : String,completion : @escaping (Result<BoardList>) -> Void) {
    api.makeNewListInBoard(rootBoard.id, nameList: name) { (result) in
     completion(result)
    }
  }
}
