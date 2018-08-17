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
    DispatchQueue.global(qos: .userInteractive).async {
      self.coreDataManager.postBoard(withName: name, color: color) { (response) in
        DispatchQueue.main.async {
          completion(response)
        }
      }
    }
  }
 
  func getAllBoardWithComplitionBlock(_ completion : @escaping (Error?) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
        self.coreDataManager.getAllBoardWithComplitionBlock { (response) in
        DispatchQueue.main.async {
           completion(response)
        }
      }
    }
  }
}
