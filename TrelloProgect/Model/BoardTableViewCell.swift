//
//  BoardTableViewCell.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/26/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class BoardTableViewCell: UITableViewCell {

  @IBOutlet weak var colorOfBoard: UIView!
  @IBOutlet weak var nameOfBoard: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
