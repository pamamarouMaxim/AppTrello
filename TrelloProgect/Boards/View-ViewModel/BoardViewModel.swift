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
  var boards : ArrayDataSource?
  
  init(api: UseOfBoards = ServerManager.default) {
    self.api = api
  }
  
  func postBoardwithName(_ name : String, color : String , completion: @escaping (Any?)  -> Void )  {
    api.postBoardwithName(name, color: color) {(result) in
      switch result{
      case .success(let board) : completion(board)
      case .failure(let error) : completion(error)
      }
    }
  }
 
  func getAllBoardWithComplitionBlock(_ completion : @escaping (Any?) -> Void) {
    api.getAllBoardWithBlock { [weak self](response) in
      var arraOfBoard = [Board]()
      if let arrayOfDict = response as? [Dictionary<String, Any>]{
        for value in arrayOfDict{
          if let name = value["name"], let id = value["id"],let presf = value["prefs"] {
            guard let nameOfBoard = name  as? String else {return}
            guard let idOfBoard   = id    as? String else {return}
            guard let presfDict   = presf as? [String : Any] else {return}
            guard let color = presfDict["backgroundColor"] else {return}
            guard let c = color as? String else {return}
            let colorOfBoard = Color(backgroundColor: c)
            let board = Board(id: idOfBoard, name: nameOfBoard, prefs: colorOfBoard)
            arraOfBoard.append(board)
          }
        }
        self?.boards = ArrayDataSource(with: arraOfBoard)
      }
      completion(nil)
    }
  }
}
