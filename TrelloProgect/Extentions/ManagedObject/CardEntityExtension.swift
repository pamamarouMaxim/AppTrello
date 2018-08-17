//
//  CardEntityExtension.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/15/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import CoreData

extension CardEntity{
  convenience init(context: NSManagedObjectContext, card: Card) {
    self.init(context: context)
    id = card.id
    name = card.name
    dueComplete = card.dueComplete
  }
}
