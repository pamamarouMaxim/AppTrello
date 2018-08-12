//
//  CBCollectionViewCell.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/8/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
   var imageView: UIImageView!

  override var reuseIdentifier: String{
    return "cell"
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    let imageView = UIImageView()
    imageView.frame = contentView.frame
    self.imageView = imageView
    contentView.addSubview(self.imageView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
 
}
