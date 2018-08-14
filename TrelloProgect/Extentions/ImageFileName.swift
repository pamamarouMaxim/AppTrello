//
//  ImageFileName.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/14/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

extension String{
  
   func imageFileName() -> String{
    var fileName = self
    fileName = fileName.replacingOccurrences(of: ".", with: "")
    fileName = fileName.replacingOccurrences(of: "https://", with: "")
    fileName = fileName.replacingOccurrences(of: "/", with: "")
    return fileName + ".png"
  }
}
