//
//  File.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/28/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BoardTableViewModel {
  
  let api: UseOfBoards
  var setting: UserInputData = UserSettings.default
  var boardsDataSource : ArrayDataSource?
  
  init(api: UseOfBoards = ServerManager.default) {
    self.api = api
  }
  
  func postBoardwithName(_ name : String, color : String , completion: @escaping (Error?)  -> Void )  {
    api.postBoardwithName(name, color: color) {(response) in
      switch response{
      case .success(_) : completion(nil)
      case .failure(let error) : completion(error)
      }
    }
  }
 
  func getAllBoardWithComplitionBlock(_ completion : @escaping (Error?) -> Void) {
    api.getAllBoardWithBlock { [weak self](response) in
      switch response{
      case .success(let boards) :
       // self?.boardsDataSource = ArrayDataSource(with:  boards.map{BoardViewModel($0)})
        completion(nil)
      case .failure(let error)   : completion(error)
      }
    }
  }
  
  func coreDataGetAllBoardWithComplitionBlock(_ completion : @escaping (Error?) -> Void) {
    CoreDataManager.default.getAllBoardWithComplitionBlock { (error) in
      
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BoardEntity")
      request.returnsObjectsAsFaults = false
      do {
        let result = try CoreDataManager.default.writeContext.fetch(request)
       
        for data in result as! [NSManagedObject] {
          print(data)
        }
        
      } catch {
        
        print("Failed")
      }
      
    }
  }
  
}
