//
//  CardsViewModel.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/31/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class CardViewModel {
  
  let api: CardOfList
   var cards : ArrayDataSource? //dataSource
  
  init(api: CardOfList = ServerManager.default) {
    self.api = api
  }
  
  func getCardsFromListWithId(_ id:String, comletion : @escaping (Error?) -> Void) {
    api.getCardsForListId(id) { [weak self](result) in
      guard let arraOfCards = JSON(result?.data as Any).array else {return}
      var  dueCompleteFalse = [Cards]()
      var  dueCompleteTrue =  [Cards]()
      for card in arraOfCards{
        guard let cardId = card["id"].string , let cardName = card["name"].string else {return}
        guard let badges = card["badges"].dictionaryObject else {return}
        guard let dueComplete =  badges["dueComplete"] as? Bool  else {return}
        let cardOfList = Cards(dueComplete: dueComplete, id: cardId, name: cardName)
        if dueComplete{
          dueCompleteTrue.append(cardOfList)
        } else {
          dueCompleteFalse.append(cardOfList)
        }
      }
      let cards = ArrayDataSource(with: [dueCompleteFalse,dueCompleteTrue])
      self?.cards = cards
      comletion(nil)
    }
  }
  
  func  postNewCardWithName(_ name : String, completion : (Error?)-> Void) {
    api.postNewCardForListId("", nameOfCard: name) { (result) in
      
    }
  }
  
  
}
