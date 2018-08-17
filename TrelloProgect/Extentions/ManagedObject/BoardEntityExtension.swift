//
//  BoardEntityExtension.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/11/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import CoreData

extension BoardEntity{
  convenience init(context: NSManagedObjectContext, board: Board) {
    self.init(context: context)
    id = board.id
    name = board.name
    backgroundColor = board.backgroundColor
  }
}

