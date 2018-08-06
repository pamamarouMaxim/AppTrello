//
//  ServerManager + CardOfList.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/29/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol CardOfList {
 func getCardsForListId(_ id: String, completion : @escaping (Result<[Card]>) -> Void)
 func postNewCardForListId(_ idOfList: String, nameOfCard: String, completion: @escaping (Result<Card>) -> Void)
}

extension ServerManager : CardOfList{

  enum URLForCards : String {
    case cardsGet = "/cards"
    case cardPost = "cards"
    case getInfo  = "cards/"
   
  }
  
  func getCardsForListId(_ id: String, completion : @escaping (Result<[Card]>) -> Void) {
    guard let token = setting.token else {return}
    guard let userId = setting.userId else {return}
    let url = ServerManager.default.rootURL + "lists/"+id + URLForCards.cardsGet.rawValue
    let method = HTTPMethod.get
    let parametrs = ["fields": "id,name,badges","key" : userId, "token" : token] as [String:Any]
    requestWithData(url, method: method, parameters: parametrs) { (response: Result<[Card]>) in
      completion(response)
    }
  }
  
  func postNewCardForListId(_ idOfList: String, nameOfCard: String, completion: @escaping (Result<Card>) -> Void) {
    guard let token = setting.token else {return}
    guard let userId = setting.userId else {return}
    let url = ServerManager.default.rootURL + URLForCards.cardPost.rawValue
    let method = HTTPMethod.post
    let parametrs = ["name" : nameOfCard ,"idList": idOfList,"key" : userId, "token" : token] as [String:Any]
    requestWithData(url, method: method, parameters: parametrs) { (response: Result<Card>) in
      completion(response)
    }
  }
}
