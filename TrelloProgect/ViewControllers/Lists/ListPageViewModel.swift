//
//  ListViewModel.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/29/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import SwiftyJSON

class ListPageViewModel {
  
  let api: UsingListsOfBoard = ServerManager.default
  var rootBoard : BoardViewModel!
  var listsDataSource : ArrayDataSource?
  var controllers : [UIViewController]?
  let coreDataManager = CoreDataManager.default
  
  init(rootBoard : BoardViewModel) {
    self.rootBoard = rootBoard
  }
  
  
  func getListsFromBoard(completion : @escaping (Error?) -> Void)  {
    coreDataManager.getListsFromBoard(rootBoard.id) { (result) in
      completion(result)
    }
  }
}
