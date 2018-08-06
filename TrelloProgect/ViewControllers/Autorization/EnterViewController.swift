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
   controllerPreparation()
  }
  
  private func controllerPreparation(){
    navigationController?.isNavigationBarHidden = true
    enterButton.layer.cornerRadius = 5
    enterButton.layer.borderWidth = 1
    enterButton.layer.borderColor = UIColor.white.cgColor
  }
}
