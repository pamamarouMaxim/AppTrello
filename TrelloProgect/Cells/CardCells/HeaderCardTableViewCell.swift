//
//  HeaderCardTableViewCell.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/8/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class HeaderCardTableViewCell: UITableViewCell,BindableCell {
  
  var viewModel: BindableCellViewModel?
  
  override var reuseIdentifier: String{
    return "HeaderCardTableViewCell"
  }
  
  func setup(with viewModel: BindableCellViewModel) {
    self.viewModel = viewModel
    guard let model = viewModel as? HeaderCardTableViewCellViewModel else {return}
    if let (cardName,listName) = model.cardAndListNames{
      textLabel?.text = cardName
      detailTextLabel?.text = "In list: " + listName
      textLabel?.textColor = UIColor.white
      detailTextLabel?.textColor = UIColor.white
      textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
      detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    contentView.backgroundColor = DefaultColor.MyColor.blue.value
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
