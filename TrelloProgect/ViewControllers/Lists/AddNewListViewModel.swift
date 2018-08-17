//
//  File.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/1/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class AddListViewModel {
  
  let api: UsingListsOfBoard
  var rootBoard : BoardViewModel
  let coreDataManager =  CoreDataManager.default
  
  init(api: UsingListsOfBoard = ServerManager.default,rootBoard : BoardViewModel) {
    self.api = api
    self.rootBoard = rootBoard
  }
    
  func   postNewListWithName(_ name : String,completion : @escaping (Any?) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
      self.coreDataManager.postNewList(withName: name, boardId: self.rootBoard.id) { (result) in
        DispatchQueue.main.async {
          if let listEntity = result as? ListEntity{
            guard let id = listEntity.id, let name = listEntity.name else {return}
              completion(BoardList(id: id, name: name))
          } else if let error = result as? Error{
            completion(error)
          }
        }
      }
    }
  }
}
