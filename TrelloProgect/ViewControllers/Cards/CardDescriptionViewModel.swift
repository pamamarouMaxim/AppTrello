//
//  File.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/6/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

class CardDiscriptionViewModel {
  
  var api  :  DetailCards
  var card : Card
  
  init(api : DetailCards, card : Card) {
    self.api = api
    self.card = card
  }
  
  func postCardDescription(description: String,completion : @escaping (Error?) -> Void) {
    api.putCardsId(card.id, description: description) { (res) in
      completion(nil)
    }
  }
}
