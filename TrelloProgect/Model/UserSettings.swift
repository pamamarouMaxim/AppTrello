//
//  UserSettings.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/24/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

private enum UserSettingsKey: String {
  case userEmail
  case userPassword
  case userId
  case token
  case member
}

class UserSettings {
  
  static let `default` = UserSettings()
  
  private let userDefaults = UserDefaults.standard
  
}

protocol UserProvidable {
  var userId: String? { get set }
  var token: String? { get set }
  var member: String? { get set }
  
}

protocol UserInputData {
  var email: String? { get set }
  var password: String? { get set }
}

  extension UserSettings: UserProvidable {
    var userId: String? {
      get {
        return userDefaults.value(forKey: UserSettingsKey.userId.rawValue) as? String
      }
      set {
        userDefaults.set(newValue, forKey: UserSettingsKey.userId.rawValue)
      }
 }
    
    var token: String? {
      get {
        return userDefaults.value(forKey: UserSettingsKey.token.rawValue) as? String
      }
      set {
        userDefaults.set(newValue, forKey: UserSettingsKey.token.rawValue)
      }
    }
    
    var member: String? {
      get {
        return  userDefaults.value(forKey: UserSettingsKey.member.rawValue) as? String
      }
      set {
        userDefaults.set(newValue, forKey: UserSettingsKey.member.rawValue)
      }
  }
}

extension UserSettings: UserInputData {
  
  var email: String? {
    get {
      return userDefaults.value(forKey: UserSettingsKey.userEmail.rawValue) as? String
    }
    set {
           userDefaults.set(newValue, forKey: UserSettingsKey.userEmail.rawValue)
    }
  }
  
  var isLoggedId: Bool {
    return email != nil
  }
  
  var password: String? {
    get {
      return userDefaults.value(forKey: UserSettingsKey.userPassword.rawValue) as? String
    }
    set {
      userDefaults.set(newValue, forKey: UserSettingsKey.userPassword.rawValue)
    }
  }
    var isPasswordId: Bool {
      return password != nil
    }
}
