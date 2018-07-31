//
//  DataSource.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/29/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit

protocol DataSource {
  func numberOfSections() -> Int
  func numberOfItems(in section: Int) -> Int
  func item(at indexPath: IndexPath) -> Any
}

class ArrayDataSource: DataSource {
  private var objects: [Any]
  
  required init(with objects: [Any]) {
    self.objects = objects
  }
  
  func numberOfSections() -> Int {
    if let values = objects as? [[Any]] {
      return values.count
    }
    return 1
  }
  
  func numberOfItems(in section: Int) -> Int {
    
    if let values = objects as? [[Any]] {
      if values.count > 1{
          return values[section].count
      }
    }
    return objects.count
  }
  
  func item(at indexPath: IndexPath) -> Any {
    if let array = objects as? [[Any]]{
      return array[indexPath.section][indexPath.row]
    }
    return objects[indexPath.row]
  }
}
