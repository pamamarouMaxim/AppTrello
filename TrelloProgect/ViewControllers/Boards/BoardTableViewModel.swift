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
  
  let coreDataManager = CoreDataManager.default
  
  func postBoardwithName(_ name : String, color : String , completion: @escaping (Error?)  -> Void )  {
    coreDataManager.postBoard(withName: name, color: color) { (response) in
      completion(response)
    }
  }
 
  func getAllBoardWithComplitionBlock(_ completion : @escaping (Error?) -> Void) {
    coreDataManager.getAllBoardWithComplitionBlock { (response) in
      completion(response)
    }
  }
}
