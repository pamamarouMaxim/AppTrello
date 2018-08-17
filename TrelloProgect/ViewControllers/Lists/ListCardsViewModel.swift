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
    DispatchQueue.global(qos: .userInteractive).async {
      self.coreDataManager.getCardsFromList(withId: self.bordList.id) { (result) in
        DispatchQueue.main.async {
           comletion(result)
        }
      }
    }
  }
  
  func  postNewCardWithName(_ name : String, completion : @escaping (Error?)-> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
      self.coreDataManager.postNewCardFromList(withId: self.bordList.id, name: name) { (result)in
        DispatchQueue.main.async {
          completion(result)
        }
      }
    }
  }
}
