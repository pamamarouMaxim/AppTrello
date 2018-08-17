//
//  ListEntityExtension.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/15/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import CoreData

extension ListEntity{
  convenience init(context: NSManagedObjectContext, list : BoardList) {
    self.init(context: context)
    id = list.id
    name = list.name
  }
}
