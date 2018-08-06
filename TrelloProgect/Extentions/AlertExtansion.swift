//
//  AlertExtantion.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/31/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
  
  static func alertWithError(_ error: Error?) -> UIAlertController {
    var message = String()
    if let tittle = error{
      message = tittle.localizedDescription
    }
    if let apiError = error as? ApiErrors{
      message = apiError.localizedDescription
    }
    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
    }))
    return alert
  }
}


