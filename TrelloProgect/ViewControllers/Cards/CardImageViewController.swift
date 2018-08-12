//
//  CardImageViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/9/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class CardImageViewController: UIViewController {
  
  var image : UIImage?
  
  @IBOutlet private weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let image = image else {return}
    imageView.image = image
  }
}
