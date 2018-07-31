//
//  File.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/26/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

struct Board : Codable{
  let id    : String
  let name  : String
  let prefs : Color
}

struct Color : Codable{
  let backgroundColor : String
}

