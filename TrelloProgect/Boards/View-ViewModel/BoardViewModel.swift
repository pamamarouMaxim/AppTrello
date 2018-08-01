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
  var boardsDataSource : ArrayDataSource?
  
  init(api: UseOfBoards = ServerManager.default) {
    self.api = api
  }
  
  func postBoardwithName(_ name : String, color : String , completion: @escaping (Any?)  -> Void )  {
    api.postBoardwithName(name, color: color) {(result) in
     completion(result)
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
            guard let colorOfBoard = color as? String else {return}
            let board = Board(id: idOfBoard, name: nameOfBoard, backgroundColor: UIColor.colorWithHexString(hex: colorOfBoard))
            arraOfBoard.append(board)
          }
        }
        self?.boardsDataSource = ArrayDataSource(with: arraOfBoard)
      }
      completion(nil)
    }
  }
}
