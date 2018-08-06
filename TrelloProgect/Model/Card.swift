//
//  Card.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/2/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

struct Card : Decodable{
  let id : String
  let name : String
  let dueComplete : Bool
  
  enum CodingKeys: String, CodingKey {
        case id
        case badges
        case name
      }
  enum PrefsKeys: String, CodingKey {
        case dueComplete
      }
}

extension Card {
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    let user = try values.nestedContainer(keyedBy: PrefsKeys.self, forKey: .badges)

    dueComplete = try user.decode(Bool.self, forKey: .dueComplete)
    id = try values.decode(String.self, forKey: .id)
    name = try values.decode(String.self, forKey: .name)
  }
}

