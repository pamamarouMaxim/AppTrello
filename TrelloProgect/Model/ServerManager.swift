//
//  File.swift
//  CBTestHomeWork
//
//  Created by Maxim Panamarou on 7/21/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

//enum Result<T> {
//  case failure(Error)
//  case success(T)
//}

class ServerManager {
  
  static let `default` = ServerManager()
  private  init() {}
  
  var setting: UserProvidable = UserSettings.default
 
  func requestWithUrl(_ url: String, method: HTTPMethod, parameters: [String: Any]?, completion: @escaping (Result<Any>) -> Void) {
     Alamofire.request((url), method: method, parameters: parameters).validate(statusCode: 200..<300).responseJSON { (response) in
      switch response.result {
      case .success(let data)  : completion(Result.success(data))
      case .failure(let error) : completion(Result.failure(error))
      }
    }
  }
}

// TODO: split different api methods to different files
protocol AuthorizationUser: class {
  func getTokenForUserWithEmail(_ email: String, password: String, completion: @escaping (Error?) -> Void)
 
}

extension ServerManager: AuthorizationUser {

  private enum ForAuthorizationUser: String {
    case codeURl  = "https://trello.com/1/authentication"
    case tokenURL = "https://trello.com/1/authorization/token"
  }
  
  func getTokenForUserWithEmail(_ email: String, password: String, completion: @escaping (Error?) -> Void) {
   
     let userParamets  = ["factors": ["user": email, "password": password], "method": "password"] as [String: Any]
     let method = HTTPMethod.post
    
    requestWithUrl(ForAuthorizationUser.codeURl.rawValue, method: method, parameters: userParamets) { [weak self] (response) in
      if response.isSuccess {
        if let dictionary = response.value as? [String: String], let code = dictionary["code"] {
            self?.getTokenWithCode(code, completion: completion)
        }
      } else if let errorDictionary = response.value as? [String: String], let errorMessage = errorDictionary["message"] {
        let error = ApiErrors.message(errorMessage)
        completion(error)
      } else {
        completion(response.error)
      }
    }
  }
  
  private func getTokenWithCode(_ code: String, completion: @escaping (Error?) -> Void) {
    
    let method = HTTPMethod.post
    setting.userId = "6287994ec401ff2bc709c4350eb2f08c"
    let paramsForToken = ["application": "6287994ec401ff2bc709c4350eb2f08c",
                          "authentication": code,
                          "token": ["scope": "read,write,account", "identifier": "Trello iOS", "expiration": "never"]] as [String: Any]
    
    requestWithUrl(ForAuthorizationUser.tokenURL.rawValue, method: method, parameters: paramsForToken, completion: { [weak self](response) in
      if response.isSuccess {
        if let dictionary = response.value as? Dictionary<String, String>, let token = dictionary["token"], let member = dictionary["member"] {
          self?.setting.token  = token
          self?.setting.member = member
          completion(nil)
        }
      } else if let errorDictionary = response.value as? Dictionary<String, String>, let errorMessage = errorDictionary["message"] {
        let error = NSError(domain: errorMessage, code: 401, userInfo: nil)
        completion(error)
      } else {
        completion(response.error)
      }
    })
  }
}

protocol UseOfBoards: class {
  func postBoardwithName(_ name: String, completion: @escaping (Error?) -> Void)
  func getAllBoardWithBlock(_ completion: @escaping (Any?) -> Void)
  func removeBoardWithId(_ id: String, completion : @escaping (Any?) -> Void)
}

extension ServerManager: UseOfBoards {

  private enum WorkWithBoardURL: String {
    case postBoardURl  = "https://api.trello.com/1/boards/"
   // case deleteBoardURL = "https://api.trello.com/1/boards/"
    case getBoardURL = "https://api.trello.com/1/members/5b51d555ccc2276b2e23c9c9/boards"
  }
  
  func postBoardwithName(_ name: String, completion: @escaping (Error?) -> Void) {
    
    if let token = setting.token, let userId = setting.userId {
      let parametrs = ["name": name,
                       "key": userId,
                       "token": token]
      requestWithUrl(WorkWithBoardURL.postBoardURl.rawValue, method: .post, parameters: parametrs) { (result) in
        if result.isFailure {
          completion(result.error)
        } else {
          completion(nil)
        }
      }
    }
  }
  
  func getAllBoardWithBlock(_ completion: @escaping (Any?) -> Void) {
    
   if let token = setting.token, let userId = setting.userId {
      let param = ["filter": "all", "fields": "id,name", "lists": "none", "memberships": "none", "key": userId, "token": token]
    let method = HTTPMethod.get
    requestWithUrl(WorkWithBoardURL.getBoardURL.rawValue, method: method, parameters: param, completion: { (result) in
      if result.isSuccess {
        //let decoder = JSONDecoder()
        completion(result.value)
      } else {
        completion(result.error)
      }
    })
   }
  }
  
  func removeBoardWithId(_ id: String, completion : @escaping (Any?) -> Void) {
    
    if let token = setting.token, let userId = setting.userId {
      var deleteBoardURL = WorkWithBoardURL.postBoardURl.rawValue + id
      let param = ["key": userId, "token": token]
      let method = HTTPMethod.delete
      requestWithUrl(deleteBoardURL, method: method, parameters: param, completion: { (result) in
        
        if result.isSuccess {
          completion(result.value)
        } else {
          completion(result.error)
        }
      })
    }
  }
  
}
