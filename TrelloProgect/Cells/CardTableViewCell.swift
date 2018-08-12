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
  makeShadow()
  }
  
  private func makeBorder(){
    layer.borderColor = UIColor.black.cgColor
    layer.borderWidth = 1
    layer.cornerRadius = 5
  }
  
  private func makeShadow(){
    self.layer.shadowOpacity = 2
    self.layer.shadowOffset = CGSize(width: 0, height: 2)
    self.layer.shadowRadius = 2
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.masksToBounds = false
  }
}
