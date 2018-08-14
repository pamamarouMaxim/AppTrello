//
//  CardsViewModel.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/31/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import SwiftyJSON

class ListCardsViewModel {
  
  var bordList : BoardList!
  let coreDataManager = CoreDataManager.default
  
   init(bordList : BoardList) {
    self.bordList = bordList
  }
  
  func getCardsFromListWithId(comletion : @escaping (Error?) -> Void) {
    coreDataManager.getCardsFromList(withId: bordList.id) { (result) in
      comletion(result)
    }
  }
  
  func  postNewCardWithName(_ name : String, completion : @escaping (Error?)-> Void) {
    coreDataManager.postNewCardFromList(withId: bordList.id, name: name) { (result) in
      completion(result)
    }
  }
}
