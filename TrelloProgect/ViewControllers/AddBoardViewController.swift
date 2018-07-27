//
//  AddBoardViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/26/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class AddBoardViewController: UITableViewController {
  
  private var addBoard: UIBarButtonItem?
  @IBOutlet weak var nameTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let createBoard = UIBarButtonItem.init(title: "Create", style: .done, target: self, action: #selector(createNewBoard(_:)))
    navigationItem.setRightBarButton(createBoard, animated: false)
    navigationItem.title = "Board"
    createBoard.isEnabled = false
    addBoard = createBoard
    nameTextField.becomeFirstResponder()
  }
  
  @objc func createNewBoard(_ sender: UIBarButtonItem) {
 
    if let nameOfBoard = nameTextField.text {
      ServerManager.default.postBoardwithName(nameOfBoard) {[weak self] (result) in
        guard result == nil else { return }
        self?.navigationController?.popViewController(animated: true)
      }
    }
  }
  
}

extension AddBoardViewController: UITextFieldDelegate {
  
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let add = addBoard {
      if add.isEnabled {
        switch textField {
        case  nameTextField : #selector(createNewBoard(_:))
        default: break
        }
      }
    }
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    addBoard?.isEnabled = !(string.isEmpty && text.count == 1)
    return true
  }
  
}
