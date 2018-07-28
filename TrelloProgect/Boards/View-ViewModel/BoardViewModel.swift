//
//  File.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/28/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit

class BoardViewModel {
  
  let api: UseOfBoards
  var setting: UserInputData = UserSettings.default
  var arrayOfBoards : [Board]?
  
  init(api: UseOfBoards = ServerManager.default) {
    self.api = api
  }
  
  func postBoardwithName(_ name : String, color : String , completion: @escaping (Error?)  -> Void )  {
    api.postBoardwithName(name, color: color) { [weak self](result) in
      
      switch result{
      case .success(let board) : self?.arrayOfBoards?.append(board)
      case .failure(let error) : completion(error)
      }
    }
  }
  
  func getAllBoardWithComplitionBlock(_ completion : @escaping (Any?) -> Void) {
    ServerManager.default.getAllBoardWithBlock { (response) in
      var arraOfBoard = [Board]()
      if let arrayOfDict = response as? [Dictionary<String, String>] {
        for value in arrayOfDict {
          if let name = value["name"], let id = value["id"] {
           // arraOfBoard.append(Board(id: id, name: name))
          }
        }
        completion(arraOfBoard)
      } else {
        completion(response)
      }
    }
  }
  
}
