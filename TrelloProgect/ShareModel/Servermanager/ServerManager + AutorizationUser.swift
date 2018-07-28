//
//  AutorizationUser.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/28/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol AuthorizationUser: class {
  func getTokenForUserWithEmail(_ email: String, password: String, completion: @escaping (Error?) -> Void)
}

extension ServerManager: AuthorizationUser {
  
  private enum ForAuthorizationUser: String {
    case codeURl  = "authentication"
    case tokenURL = "authorization/token"
  }
  
  func getTokenForUserWithEmail(_ email: String, password: String, completion: @escaping (Error?) -> Void) {
    let userParamets  = ["factors": ["user": email, "password": password], "method": "password"] as [String: Any]
    let method = HTTPMethod.post
    requestWithUrl(self.rootURL + ForAuthorizationUser.codeURl.rawValue, method: method, parameters: userParamets,
                   completion: { [weak self](response) in
      switch response{
      case .success(let success) :
        if  let dictionary = success as? [String: String],let code  =  dictionary["code"]{
          self?.getTokenWithCode(code, completion: completion)
        } else if let errorDictionary = success as? [String: String], let errorMessage = errorDictionary["message"]{
          completion(ApiErrors.message(errorMessage))
        } else {
          completion(ApiErrors.message("Error"))
        }
      case .failure(let failure) : completion(failure)
      }
      })
  }

   func getTokenWithCode(_ code: String, completion: @escaping (Error?) -> Void) {
    
    let method = HTTPMethod.post
    guard  let userId = setting.userId else {return}
    let paramsForToken = ["application": userId,
                          "authentication": code,
                          "token": ["scope": "read,write,account", "identifier": "Trello iOS", "expiration": "never"]] as [String: Any]
    
    requestWithUrl(self.rootURL + ForAuthorizationUser.tokenURL.rawValue, method : method, parameters: paramsForToken,
                   completion: { [weak self](response) in
      switch response{
      case .success(let success) :
        if let dictionary = success as? Dictionary<String, String>, let token = dictionary["token"], let member = dictionary["member"] {
          self?.setting.token  = token
          self?.setting.member = member
          completion(nil)
        } else if let errorDictionary = success as? Dictionary<String, String>, let errorMessage = errorDictionary["message"] {
          completion(ApiErrors.message(errorMessage))
        } else {
          completion(ApiErrors.message("Error"))
        }
      case .failure(let failure) : completion(failure)
    }
  })
 }
}
