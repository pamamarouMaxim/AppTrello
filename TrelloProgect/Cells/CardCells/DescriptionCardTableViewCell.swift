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
    textLabel?.numberOfLines = 0
    if  let description = viewModel.description{
      if !description.isEmpty{
        textLabel?.text = description
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
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
    }

}
