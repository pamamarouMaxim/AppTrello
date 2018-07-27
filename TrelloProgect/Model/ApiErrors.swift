//
//  ApiErrors.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/26/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

enum ApiErrors: Error {
  case message(String)
}

extension ApiErrors {
  var localizedDescription: String {
    switch self {
    case .message(let messageString): return messageString
    }
  }
}
