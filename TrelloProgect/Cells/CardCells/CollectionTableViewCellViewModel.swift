//
//  CollectionTableViewCellViewModel.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/10/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit

class CollectionTableViewCellViewModel: BindableCellViewModel {
  
  var cardInfo : CardEntity?
  var attachments : [String]?
  var cellClass: Reusable.Type
  
  init(cellClass : Reusable.Type) {
    self.cellClass = cellClass
  }
  
  func getImage(FromUrlSring stringUrl : String, complition :  @escaping (UIImage?)-> Void) {
    DispatchQueue.global().async {
      guard let url = URL(string: stringUrl) else {return}
      let object = LocalImagesProvider.default
      object.getImage(FromUrl: url) { (image) in
        DispatchQueue.main.async {
            complition(image)
          }
        }
    }
  }
}

