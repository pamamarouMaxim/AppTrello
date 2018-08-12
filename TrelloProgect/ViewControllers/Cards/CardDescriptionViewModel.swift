//
//  File.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/6/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

class CardDescriptionViewModel {
  
  var api  :  DetailCards
  var card : Card
  var descriptionText : String
  
  init(api : DetailCards, card : Card, descriptionText : String) {
    self.api = api
    self.card = card
    self.descriptionText = descriptionText
  }
  
  func postCardDescription(description: String,completion : @escaping (Error?) -> Void) {
    api.putCardsId(card.id, description: description) { (res) in
      completion(nil)
    }
  }
}
