//
//  CollectionViewTableViewCell.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/6/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit
import CoreData

protocol Reusable: class {
  static var nib: UINib { get }
  static var reuseIdentifier: String { get }
}

extension Reusable{
  static var nib : UINib {
    return UINib(nibName: String(describing: Self.self), bundle:  nil)
  }
  
  static var reuseIdentifier: String {
    return String(describing: Self.self) + "Identifier"
  }
}

protocol  BindableCellViewModel{
  var  cellClass :  Reusable.Type { get }
}

protocol BindableCell : Reusable {
  func setup(with viewModel: BindableCellViewModel)
}
