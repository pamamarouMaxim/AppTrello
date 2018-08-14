//
//  CollectionViewTableViewCell.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/6/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit
import CoreData

class CellViewModel :  BindableCellViewModel{
  
  var cardInfo : CardEntity?
  
  var image: UIImage?
  
  var images: [UIImage]?
  
  var cardAndListNames : (String,String)?
  
  private var UrlString : String?
  
   var cellClass: Reusable.Type
  
  init(cellClass : Reusable.Type) {
    self.cellClass = cellClass
  }
  
  // collection
  func getImage(FromUrlSring stringUrl : String, complition :  @escaping (UIImage?)-> Void) {
    guard let url = URL(string: stringUrl) else {return}
    let object = GetSaveImageLocal()
    object.getImage(FromUrl: url) { (image) in
      complition(image)
    }
  }
}

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
  
//  var image : UIImage? {get set}
//  var images: [UIImage]? {get set}
//  var cardAndListNames : (String,String)? {get set}
//  var cardInfo : CardEntity? {get set}
//
  var  cellClass :  Reusable.Type { get }
//
//  func getImage(FromUrlSring stringUrl : String, complition :  @escaping (UIImage?)-> Void)
}

protocol BindableCell : Reusable {
  //var viewModel : BindableCellViewModel? { get set }
  func setup(with viewModel: BindableCellViewModel)
}
