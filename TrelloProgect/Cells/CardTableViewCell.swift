//
//  CardTableViewCell.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/30/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

  var cardId : String?
  
  @IBOutlet weak var cardNameLable: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
    makeBorder()
  }
  
  private func makeBorder(){
    layer.borderColor = UIColor.black.cgColor
    layer.borderWidth = 1
    layer.cornerRadius = 3
  }
}
