//
//  ServerManager + ListOfBoard.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/29/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import Alamofire

protocol UsingListsOfBoard: class {
  func getListsForBoard(_ idOfBoard: String, completion: @escaping (DataResponse<Data>?) -> Void)
  func makeNewListInBoard(_ idBoard : String,nameList : String, completion : @escaping (Result<Any>) -> Void)
}

extension ServerManager : UsingListsOfBoard{
  
  enum URLForList : String {
    case getAllList = "boards/"
    case newList    = "lists"
  }

  func getListsForBoard(_ idOfBoard: String, completion: @escaping (DataResponse<Data>?) -> Void){
    guard let token = setting.token,let userId = setting.userId else {return}
    let url = ServerManager.default.rootURL + URLForList.getAllList.rawValue + idOfBoard + "/lists"
    let method = HTTPMethod.get
    let parametrs = ["fields" : "name,id","key" : userId, "token" : token] as [String:Any]
    requestReturnData(url, method: method, parameters: parametrs) { (response) in
      completion(response)
    }
  }
  
  func makeNewListInBoard(_ idBoard : String,nameList : String, completion : @escaping (Result<Any>) -> Void){
    guard let token = setting.token else {return}
    guard let userId = setting.userId else {return}
    let url = ServerManager.default.rootURL + URLForList.newList.rawValue
    let method = HTTPMethod.post
    let parametrs = ["name": nameList,"idBoard" : idBoard ,"key" : userId, "token" : token] as [String:Any]
    requestWithUrl(url, method: method, parameters: parametrs) { (result) in
      completion(result)
    }
  }  
}
