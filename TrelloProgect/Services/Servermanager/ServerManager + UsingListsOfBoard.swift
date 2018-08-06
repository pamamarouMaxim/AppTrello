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
  func getListsForBoard(_ idOfBoard: String, completion: @escaping (Result<[BoardList]>) -> Void)
  func makeNewListInBoard(_ idBoard : String,nameList : String, completion : @escaping (Result<BoardList>) -> Void)
}

extension ServerManager : UsingListsOfBoard{
  
  enum URLForList : String {
    case getAllList = "boards/"
    case newList    = "lists"
  }

  func getListsForBoard(_ idOfBoard: String, completion: @escaping (Result<[BoardList]>) -> Void){
    guard let token = setting.token,let userId = setting.userId else {return}
    let url = ServerManager.default.rootURL + URLForList.getAllList.rawValue + idOfBoard + "/lists"
    let method = HTTPMethod.get
    let parametrs = ["fields" : "name,id","key" : userId, "token" : token] as [String:Any]
    requestWithData(url, method: method, parameters: parametrs) { (result : Result<[BoardList]>) in
      completion(result)
    }
  }
  
  func makeNewListInBoard(_ idBoard : String,nameList : String, completion : @escaping (Result<BoardList>) -> Void){
    guard let token = setting.token else {return}
    guard let userId = setting.userId else {return}
    let url = ServerManager.default.rootURL + URLForList.newList.rawValue
    let method = HTTPMethod.post
    let parametrs = ["name": nameList,"idBoard" : idBoard ,"key" : userId, "token" : token] as [String:Any]
    requestWithData(url, method: method, parameters: parametrs) { (result : Result<BoardList>) in
      completion(result)
    }
  }  
}
