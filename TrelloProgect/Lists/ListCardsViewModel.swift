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

class ListCardsViewModel {
  
  let api: CardOfList =  ServerManager.default
  var bordList : BoardList!
  var cardsDataSource : ArrayDataSource? 
  
   init(bordList : BoardList) {
    self.bordList = bordList
  }
  
  func getCardsFromListWithId(comletion : @escaping (Error?) -> Void) {
    api.getCardsForListId(bordList.id) { [weak self](result) in
      guard let arraOfCards = JSON(result?.data as Any).array else {return}
      var  dueCompleteFalse = [Card]()
      var  dueCompleteTrue =  [Card]()
      for card in arraOfCards{
        guard let cardId = card["id"].string , let cardName = card["name"].string else {return}
        guard let badges = card["badges"].dictionaryObject else {return}
        guard let dueComplete =  badges["dueComplete"] as? Bool  else {return}
        let cardOfList = Card(dueComplete: dueComplete, id: cardId, name: cardName)
        if dueComplete{
          dueCompleteTrue.append(cardOfList)
        } else {
          dueCompleteFalse.append(cardOfList)
        }
      }
      let cards = ArrayDataSource(with: [dueCompleteFalse,dueCompleteTrue])
      
      self?.cardsDataSource = cards
      comletion(nil)
    }
  }
  
  func  postNewCardWithName(_ name : String, completion : @escaping (Error?)-> Void) {
    api.postNewCardForListId(bordList.id, nameOfCard: name) { (result) in
      completion(nil)
    }
  }
}
