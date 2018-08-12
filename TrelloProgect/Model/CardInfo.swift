//
//  CardInfo.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/5/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

struct CardInfo : Decodable {
  var due : String
  var desc : String
  var labels : [String]
  var attachments : [String]

  enum CodingKeys: String, CodingKey {
    case due
    case desc
    case labels
    case attachments
  }
}

extension CardInfo {
  init(from decoder: Decoder) throws {
    
    let values = try decoder.container(keyedBy: CodingKeys.self)
    
    let label = try values.decode([Dictionary<String,String>].self, forKey: .labels)
    var colors = [String]()
    for value in label{
      if let color = value["color"]{
        colors.append(color)
      }
    }
    
  let array = try values.decode(AnyDecodable.self, forKey: .attachments)
  var attachmentUrl = [String]()
    if let objects =  array.value as? [Dictionary<String,Any>]{
      for value in objects{
        let preview =  value["previews"] as? [Dictionary<String,Any>]
        if let firstPreview =  preview?.last{
          if let url = firstPreview["url"] as? String{
             attachmentUrl.append(url)
          }
        }
      }
    }
    
    let date = try values.decode(String?.self, forKey: .due)
    if date == nil{
      due = ""
    } else {
      due = date!
    }
    
    labels  = colors
    desc   = try values.decode(String.self, forKey: .desc)
    attachments = attachmentUrl
  }
}
