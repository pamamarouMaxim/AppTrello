//
//  ServerManager + CardOfList.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/29/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import Alamofire


protocol CardOfList {
  func postNewCardForListId(_ idOfList : String,nameOfCard: String, completion : (Error?) -> Void)
  func getCardsForListId(_ id: String, completion : @escaping (DataResponse<Data>?) -> Void)
}

extension ServerManager : CardOfList{

  func getCardsForListId(_ id: String, completion : @escaping (DataResponse<Data>?) -> Void) {
    guard let token = setting.token else {return}
    guard let userId = setting.userId else {return}
    let url = "https://api.trello.com/1/lists/"+id + "/cards"
    let method = HTTPMethod.get
    let parametrs = ["fields" : "id,name,badges","key" : userId, "token" : token] as [String:Any]
    requestReturnData(url, method: method, parameters: parametrs) { (response) in
      completion(response)
    }
  }
  
  
  func postNewCardForListId(_ idOfList: String, nameOfCard: String, completion: (Error?) -> Void) {
    guard let token = setting.token else {return}
    guard let userId = setting.userId else {return}
    let url = ServerManager.default.rootURL + URLForList.newList.rawValue
    let method = HTTPMethod.post
    let parametrs = ["name" : nameOfCard ,"idList": idOfList,"key" : userId, "token" : token] as [String:Any]
    requestWithUrl(url, method: method, parameters: parametrs) { (result) in
    }
  }
  
}
