//
//  LoginValidation.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/24/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

extension String {
  
  var isValidPassword: Bool {
      return self.count > 7
  }
  
  var isValidEmail: Bool {
    let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
    return  pred.evaluate(with: self)
  }
}
