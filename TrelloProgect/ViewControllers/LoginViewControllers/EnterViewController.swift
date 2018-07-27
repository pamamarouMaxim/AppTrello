//
//  File.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/24/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

import UIKit

class CBEnterViewController: UIViewController {
  
  @IBOutlet private weak var enterButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
    self.enterButton.layer.cornerRadius = 5
    self.enterButton.layer.borderWidth = 1
    self.enterButton.layer.borderColor = UIColor.white.cgColor
  }
}
