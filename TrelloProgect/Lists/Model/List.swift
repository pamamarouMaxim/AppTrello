//
//  LIST.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/29/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

struct ListOfBoard : Codable{
  let id : String
  let name : String
}

////////////////////////////////

struct List : Codable{
  var cards : [Cards]
  let id : String
  let idBoard : String
  let name : String
}

struct Cards : Codable{
  let dueComplete: Bool
  let id : String
  let name : String
}

