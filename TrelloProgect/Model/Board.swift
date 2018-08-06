//
//  File.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/26/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit

struct Board : Decodable {
  let id    : String
  let name  : String
  let backgroundColor : String
  
  enum CodingKeys: String, CodingKey {
    case id
    case prefs
    case name
  }

  enum PrefsKeys: String, CodingKey {
    case backgroundColor
  }
}

extension Board {
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    let user = try values.nestedContainer(keyedBy: PrefsKeys.self, forKey: .prefs)

    backgroundColor = try user.decode(String.self, forKey: .backgroundColor)
    id = try values.decode(String.self, forKey: .id)
    name = try values.decode(String.self, forKey: .name)
  }
}
