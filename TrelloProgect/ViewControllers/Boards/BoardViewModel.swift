//
//  File.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/28/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit

class BoardViewModel {
  
  let id    : String
  let name  : String
  let backgroundColor : UIColor
  
  init(_ board: Board) {
    self.id = board.id
    self.name = board.name
    self.backgroundColor = UIColor.colorWithHexString(hex: board.backgroundColor)
  }
}
