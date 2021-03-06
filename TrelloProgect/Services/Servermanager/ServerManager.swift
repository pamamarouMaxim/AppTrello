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
import SwiftyJSON

enum Result<T> {
  case success(T)
  case failure(Error)
}

class ServerManager {
  
  var setting: UserProvidable = UserSettings.default
  let rootURL = "https://api.trello.com/1/"
  
  static let `default` = ServerManager()
  
  private  init() {
      setting.userId = "6287994ec401ff2bc709c4350eb2f08c"
  }
  
  func requestWithUrl(_ url: String, method: HTTPMethod, parameters: [String: Any]?, completion: @escaping (Result<Any>) -> Void) {
     Alamofire.request((url), method: method, parameters: parameters).responseJSON { (response) in
      switch response.result {
      case .success(let data)  : completion(Result.success(data))
      case .failure(let error) : completion(Result.failure(error))
      }
    }
  }
  
  func requestWithData<T : Decodable>(_ url: String, method: HTTPMethod, parameters: [String: Any]?, completion: @escaping (Result<T>) -> Void) {
    Alamofire.request((url), method: method, parameters: parameters).responseData { (response) in
      switch response.result{
      case .success(let data) :
        do{
          let coder = JSONDecoder()
          let result = try coder.decode(T.self, from: data)
          completion(Result.success(result))
        } catch {
          completion(Result.failure(error))
        }
      case .failure(let error): completion(Result.failure(error))
      }
    }
  }
}
