//
//  DescriptionCardTableViewCellViewModel.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/10/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

class DescriptionCardTableViewCellViewModel :  BindableCellViewModel{
  
  var cardInfo : CardEntity?
  
  var cellClass: Reusable.Type
  
  init(cellClass : Reusable.Type) {
    self.cellClass = cellClass
  }
}

