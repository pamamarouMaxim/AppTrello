//
//  DefaultColors.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/7/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit

class DefaultColor{
  
  enum MyColor : String{
    case red     = "red"
    case blue    = "blue"
    case orange  = "orange"
    case green   = "green"
    case purple = "purple"
    case pink    = "pink"
    case lime    = "lime"
    case sky     = "sky"
    case gray    = "gray"
    
    var value: UIColor {
      get {
        switch self {
        case .red:
          return UIColor.red
        case .blue:
          return UIColor.blue
        case .orange:
          return UIColor.orange
        case .green:
          return UIColor.green
        case .purple:
          return UIColor.purple
        case .gray:
          return UIColor.gray
        case .lime:
          return UIColor(red: 174/255, green: 255/255, blue: 204/255, alpha: 1)
        case .pink:
          return UIColor(red: 233/255, green: 92/255, blue: 235/255, alpha: 1)
        case .sky:
          return UIColor(red: 75/255, green: 255/255, blue: 235/255, alpha: 1)
        }
      }
    }
  }
}
