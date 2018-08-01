//
//  ServerManager + UsingBoards.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/28/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol UseOfBoards: class {
  func postBoardwithName(_ name: String,color : String, completion: @escaping (Any?) -> Void)
  func getAllBoardWithBlock(_ completion: @escaping (Any?) -> Void)
  func removeBoardWithId(_ id: String, completion : @escaping (Any?) -> Void)
}

extension ServerManager: UseOfBoards {
  
  private enum WorkWithBoardURL: String {
    case deleteOrPostBoardURl  = "boards/"
    case getBoardURL = "members/5b51d555ccc2276b2e23c9c9/boards"
  }
  
  func postBoardwithName(_ name: String,color : String, completion: @escaping (Any?) -> Void) {
    
    if let token = setting.token, let userId = setting.userId {
      let parametrs = ["name": name,
                       "key": userId,
                       "prefs_background": color,
                        "token": token] as [String : Any]
      let url = self.rootURL + WorkWithBoardURL.deleteOrPostBoardURl.rawValue
      
      requestWithUrl(url, method: HTTPMethod.post, parameters: parametrs, completion: { (result) in
        completion(result)
      })
    }
  }
  
  func getAllBoardWithBlock(_ completion: @escaping (Any?) -> Void) {
    
    if let token = setting.token, let userId = setting.userId {
      let param = ["filter": "all", "fields": "id,name,prefs", "lists": "none", "memberships": "none", "key": userId, "token": token]
      let method = HTTPMethod.get
      requestWithUrl(self.rootURL + WorkWithBoardURL.getBoardURL.rawValue, method: method, parameters: param, completion: { (result) in
        switch result{
        case .success(let success): completion(success)
        case .failure(let error)  : completion(error)
        }
      })
    }
  }
  
  func removeBoardWithId(_ id: String, completion : @escaping (Any?) -> Void) {
    if let token = setting.token, let userId = setting.userId {
      let deleteBoardURL = WorkWithBoardURL.deleteOrPostBoardURl.rawValue + id
      let param = ["key": userId, "token": token]
      let method = HTTPMethod.delete
      requestWithUrl(self.rootURL + deleteBoardURL, method: method, parameters: param, completion: { (result) in
        switch result{
        case .success(let success): completion(success)
        case .failure(let error)  : completion(error)
        }
      })
    }
  }
  
}
