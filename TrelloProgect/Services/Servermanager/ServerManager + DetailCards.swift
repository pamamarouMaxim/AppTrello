//
//  ServerManager + DetailCards.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/5/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireImage


protocol DetailCards {
  func getCardInfo(_ cardId: String, completion: @escaping (Result<CardInfo>) -> Void)
  func getImageAttachmentUrl(_ url : String, completion: @escaping (Image?) -> Void)
  func putCardsId(_ cardId: String, description : String, completion : @escaping (Any?) -> Void)
}

extension ServerManager : DetailCards{
  
  enum URLForDetailCard : String {
    case getInfo  = "cards/"
    case attachment = "/attachments"
  }
  
  func getCardInfo(_ cardId: String, completion: @escaping (Result<CardInfo>) -> Void) {
    guard let token = setting.token else {return}
    guard let userId = setting.userId else {return}
    let url = ServerManager.default.rootURL + URLForDetailCard.getInfo.rawValue + cardId
    let method = HTTPMethod.get
    let parametrs = ["fields":"desc,due,labels","attachments" : "true","attachment_fields" : "previews","checklists":"none","key" : userId, "token" : token] as [String:Any]
    requestWithData(url, method: method, parameters: parametrs) { (result : Result<CardInfo>) in
      completion(result)
    }
    
    
  }
  
  func putCardsId(_ cardId: String, description : String, completion : @escaping (Any?) -> Void){
    guard let token = setting.token else {return}
    guard let userId = setting.userId else {return}
    let url = ServerManager.default.rootURL + URLForDetailCard.getInfo.rawValue + cardId
    let method = HTTPMethod.put
    let parametrs = ["desc": description,"key" : userId, "token" : token] as [String:Any]
    requestWithData(url, method: method, parameters: parametrs) { (result : Result<CardInfo> ) in
      completion(result)
    }
  }
  
  func getImageAttachmentUrl(_ url : String, completion: @escaping (Image?) -> Void) {
    Alamofire.request(url).responseImage { response in
      completion(response.result.value)
    }
  }
}
