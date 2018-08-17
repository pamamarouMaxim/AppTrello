//
//  DescriptionCardTableViewCell.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/8/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class DescriptionCardTableViewCell: UITableViewCell,BindableCell {

  var viewModel: BindableCellViewModel?
  
  func setup(with viewModel: BindableCellViewModel) {
    self.viewModel = viewModel
    guard  let descrModel = viewModel as? DescriptionCardTableViewCellViewModel else { return }
    textLabel?.numberOfLines = 0
    if  let cardInfo = descrModel.cardInfo{
      if cardInfo.desc != ""{
        textLabel?.text = cardInfo.desc
      } else {
        textLabel?.text = "Tap to add description"
        textLabel?.textColor = UIColor.lightGray
      }
    }
  }
  
  override var reuseIdentifier: String{
    return "DescriptionCardTableViewCell"
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
