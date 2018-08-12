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
  convenience init(entity: NSEntityDescription, insertInto: NSManagedObjectContext?, board : Board) {
    self.init(entity: entity, insertInto: insertInto)
    setValue(board.id, forKey: "id")
    setValue(board.name, forKey: "name")
    setValue(board.backgroundColor, forKey: "backgroundColor")
  }
}

extension ListEnity{
  convenience init(entity: NSEntityDescription, insertInto: NSManagedObjectContext?, list : BoardList) {
    self.init(entity: entity, insertInto: insertInto)
    setValue(list.id, forKey: "id")
    setValue(list.name, forKey: "name")
  }
}

extension CardEntity{
  convenience init(entity: NSEntityDescription, insertInto: NSManagedObjectContext?, card : Card) {
    self.init(entity: entity, insertInto: insertInto)
    setValue(card.id, forKey: "id")
    setValue(card.name, forKey: "name")
    setValue(card.dueComplete, forKey: "dueComplete")
  }
}
