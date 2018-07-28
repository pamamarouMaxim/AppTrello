//
//  File.swift
//
//
//  Created by Maxim Panamarou on 7/24/18.

import Foundation
import UIKit

// TODO: split view models (1 VC - 1 VM)
class ViewModel {
  
  var setting: UserInputData = UserSettings.default
  
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
      if let arrayOfDict = response as? [Dictionary<String, Any>] {
        for value in arrayOfDict {
          if let name = value["name"], let id = value["id"],let prefs = value["prefs"]  {
            guard let color = prefs as? [String: Any] else {return}
            guard let background = color["backgroundColor"]  else {return}
            let hexColor = String(describing: background)
            arraOfBoard.append(Board(id: id as! String, name: name as! String, hexColor : hexColor))
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



