//
//  CollectionViewTableViewCell.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/6/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class CellViewModel :  BindableCellViewModel{
  
  var image: UIImage?
  
  var images: [UIImage]?
  
  var due: String?
  
  var description: String?
  
  var cardAndListNames : (String,String)?
  
  var attachments : [String]?
  
  private var UrlString : String?
  
   var cellClass: Reusable.Type
  
  init(cellClass : Reusable.Type) {
    self.cellClass = cellClass
  }
  
  // collection
  
  func getImage(FromUrlSring stringUrl : String, complition :  @escaping (UIImage?)-> Void) {
    guard let url = URL(string: stringUrl) else {return}
    let image = try? Data(contentsOf: url )
    if let picture = image{
       let image = UIImage(data :picture)
      complition(image)
    }
    complition(nil)
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
  
  var image : UIImage? {get set}
  var images: [UIImage]? {get set}
  var due : String? {get set}
  var description : String? {get set}
  var cardAndListNames : (String,String)? {get set}
  var attachments : [String]? {get set}
  
  var  cellClass :  Reusable.Type { get }
  
  func getImage(FromUrlSring stringUrl : String, complition :  @escaping (UIImage?)-> Void)
}


protocol BindableCell : Reusable {
  var viewModel : BindableCellViewModel? { get set }
  func setup(with viewModel: BindableCellViewModel)
}

//
//let api: UseOfBoards
//var setting: UserInputData = UserSettings.default
//var boardsDataSource : ArrayDataSource?
//
//init(api: UseOfBoards = ServerManager.default) {
//  self.api = api
//}
//
////////
//
//let api: AuthorizationUser
//var setting: UserInputData = UserSettings.default
//
//init(api: AuthorizationUser = ServerManager.default) {
//  self.api = api
//}

