//
//  CardCellTableViewCell.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/6/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class CardCellTableViewCell: UITableViewCell,BindableCell {
  
  var viewModel: BindableCellViewModel?
  
  func setup(with viewModel: BindableCellViewModel) {
    self.viewModel = viewModel
    if let image = viewModel.image{
      cellImage.image = image
      if let date = viewModel.due{
        if date != ""{
          var  due = date.replacingOccurrences(of: "T", with: " ")
          if let index = due.range(of: ".")?.lowerBound {
            let substring = due[..<index]
            due = String(substring)
          }
          cellLabel.text = due
        } else {
           cellLabel.text = "Completion date"
          cellLabel.textColor = UIColor.lightGray
        }
      }
    }
  }
  
  @IBOutlet weak var cellImage: UIImageView!
  @IBOutlet weak var cellLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
