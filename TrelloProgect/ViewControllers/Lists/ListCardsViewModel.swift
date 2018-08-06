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
  
  let api: CardOfList =  ServerManager.default
  var bordList : BoardList!
  var cardsDataSource : ArrayDataSource?
  private var dueCompleteFalse: [Card]?
  private var dueCompleteTrue: [Card]?
  
   init(bordList : BoardList) {
    self.bordList = bordList
  }
  
  func getCardsFromListWithId(comletion : @escaping (Error?) -> Void) {
    api.getCardsForListId(bordList.id) { [weak self](result) in
      switch result{
      case .success(let cards) :
         self?.dueCompleteFalse = cards.filter({ $0.dueComplete == false})
         self?.dueCompleteTrue = cards.filter({ $0.dueComplete == true})
        let complete = self?.dueCompleteTrue    ?? [Card]()
        let notComplete = self?.dueCompleteFalse ?? [Card]()
        self?.cardsDataSource = ArrayDataSource(with: [notComplete,complete])
        comletion(nil)
      case .failure(let error) : comletion(error)
      }
    }
  }
  
  func  postNewCardWithName(_ name : String, completion : @escaping (Error?)-> Void) {
    api.postNewCardForListId(bordList.id, nameOfCard: name) { [weak self](result) in
      switch result{
      case .success(let card) :
        self?.dueCompleteFalse?.append(card)
        let complete = self?.dueCompleteTrue    ?? [Card]()
        let notComplete = self?.dueCompleteFalse ?? [Card]()
        self?.cardsDataSource = ArrayDataSource(with: [notComplete,complete])
        completion(nil)
      case .failure(let error) : completion(error)
      }
    }
  }
}
