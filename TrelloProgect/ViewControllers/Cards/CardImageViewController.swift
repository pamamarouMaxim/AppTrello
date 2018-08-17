//
//  CardImageViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/9/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class CardImageViewController: UIViewController {
  
  var pathToImage : String?
  
  @IBOutlet private weak var imageView: UIImageView!
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let path = pathToImage else {return}
    guard let url = URL(string: path)  else {return}
    LocalImagesProvider.default.getImage(FromUrl: url) { (image) in
      if let image = image {
         imageView.image = image
      }
    }
  }
}
