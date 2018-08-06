//
//  CardInfo.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/5/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

struct CardInfo : Codable {
  let date : String
  let desc : String
  let labels : [String]
  var attachments : [String]
}
