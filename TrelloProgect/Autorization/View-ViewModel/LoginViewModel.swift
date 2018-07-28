//
//  LoginViewModel.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/28/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

import Foundation
import UIKit

// TODO: split view models (1 VC - 1 VM)
class LoginViewModel {
  
  let api: AuthorizationUser
  var setting: UserInputData = UserSettings.default
  
  
  init(api: AuthorizationUser = ServerManager.default) {
    self.api = api
  }
  
  func authorizeUserWithEmail(_ email: String, password: String, completion: @escaping ((Error?) -> Void)) {
    if email.isValidEmail && password.isValidPassword {
      setting.email = email
      setting.password = password
      api.getTokenForUserWithEmail(email, password: password, completion: { (response) in
        completion(response)
      })
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
