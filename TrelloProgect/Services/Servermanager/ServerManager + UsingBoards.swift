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
  func postBoardwithName(_ name: String,color : String, completion: @escaping (Result<Board>) -> Void)
  func getAllBoardWithBlock(_ completion: @escaping (Result<[Board]>) -> Void)
  func removeBoardWithId(_ id: String, completion : @escaping (Result<Board>) -> Void)
}

extension ServerManager: UseOfBoards {
  
  private enum WorkWithBoardURL: String {
    case deleteOrPostBoardURl  = "boards/"
    case getBoardURL = "members/5b51d555ccc2276b2e23c9c9/boards"
  }
  
  func postBoardwithName(_ name: String,color : String, completion: @escaping (Result<Board>) -> Void) {
    if let token = setting.token, let userId = setting.userId {
      let parametrs = ["name": name,
                       "key": userId,
                       "prefs_background": color,
                        "token": token] as [String : Any]
      let url = self.rootURL + WorkWithBoardURL.deleteOrPostBoardURl.rawValue
      requestWithData(url, method: HTTPMethod.post, parameters: parametrs, completion: { (result : Result<Board>) in
         completion(result)
      })
    }
  }
  
  func getAllBoardWithBlock(_ completion: @escaping (Result<[Board]>) -> Void) {
    
    if let token = setting.token, let userId = setting.userId {
      let param = ["filter": "all", "fields": "id,name,prefs", "lists": "none", "memberships": "none", "key": userId, "token": token]
      let method = HTTPMethod.get
      requestWithData(self.rootURL + WorkWithBoardURL.getBoardURL.rawValue, method: method, parameters: param, completion: { (result : Result<[Board]>) in
        completion(result)
      })
  
    }
  }
  
  func removeBoardWithId(_ id: String, completion : @escaping (Result<Board>) -> Void) {
    if let token = setting.token, let userId = setting.userId {
      let deleteBoardURL = WorkWithBoardURL.deleteOrPostBoardURl.rawValue + id
      let param = ["key": userId, "token": token]
      let method = HTTPMethod.delete
      requestWithData(self.rootURL + deleteBoardURL, method: method, parameters: param, completion: { (result : Result<Board>) in
        completion(result)
      })
      
    }
  }
  
}
