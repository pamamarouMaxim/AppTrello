//
//  File.swift
//
//
//  Created by Maxim Panamarou on 7/24/18.

import Foundation
import UIKit

var setting: UserInputData = UserSettings.default

// TODO: split view models (1 VC - 1 VM)
class ViewModel {
  
  let api: AuthorizationUser
  
  init(api: AuthorizationUser = ServerManager.default) {
    self.api = api
  }
  
  func authorizeUserWithEmail(_ email: String, password: String, completion: @escaping ((Error?) -> Void)) {
    
    if email.isValidEmail && password.isValidPassword {
      setting.email = email
      setting.password = password
      //TODO: use api
      ServerManager.default.getTokenForUserWithEmail(email, password: password, completion: { (response) in
        if let response = response {
          completion(response)
        } else {
          completion(nil)
        }
      })
    } else {
      // TODO: create custom ValidationError
      let errorPassword = NSError(domain: "Incorrect e-mail adress or password",
                                code: 400,
                                userInfo: nil)
      completion(errorPassword)
    }
  }
  
  func getAllBoardWithComplitionBlock(_ completion : @escaping (Any?) -> Void) {
    ServerManager.default.getAllBoardWithBlock { (response) in
      var arraOfBoard = [Board]()
      if let arrayOfDict = response as? [Dictionary<String, String>] {
        for value in arrayOfDict {
          if let name = value["name"], let id = value["id"] {
            arraOfBoard.append(Board(id: id, name: name))
          }
        }
        completion(arraOfBoard)
      } else {
        completion(response)
      }
    }
  }
  
  func loadEmail() -> String {
    if let email = setting.email {return email} else {return ""}
  }
  
  func loadPassword() -> String {
    if let password = setting.password {return password} else {return ""}
  }
  
  func removeLogin() {
    setting.email = nil
    setting.password = nil
  }

}
