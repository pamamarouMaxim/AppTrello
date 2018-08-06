//
//  AddBoardViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/26/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class AddBoardViewController: UITableViewController {
  
  var selectedCellInColor : UITableViewCell?
  var boardTableViewModel : BoardTableViewModel?
 
  @IBOutlet private weak var selectedСolorView: UIView!
  @IBOutlet private weak var nameTextField: UITextField!
  
  private var nameOfSelectedColor = "blue"
  private var addBoard: UIBarButtonItem!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
   preparationToShow()
  }
  
  override func viewWillAppear(_ animated: Bool) {
   preparationSendCell()
  }
  
  override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    tableView.deselectRow(at: indexPath, animated: false)
  }
  
  private func preparationToShow(){
    let createBoard = UIBarButtonItem.init(title: "Create", style: .done, target: self, action: #selector(createNewBoard(_:)))
    navigationItem.setRightBarButton(createBoard, animated: false)
    navigationItem.title = "Board"
    createBoard.isEnabled = false
    addBoard = createBoard
    nameTextField.becomeFirstResponder()
  }
  
  private func preparationSendCell(){
    guard let cell = selectedCellInColor else {return}
    selectedСolorView.backgroundColor = cell.contentView.backgroundColor
    guard let text = cell.textLabel?.text else {return}
    nameOfSelectedColor = text
  }
  
  @objc private func createNewBoard(_ sender: UIBarButtonItem?) {
    guard let nameOfBoard = nameTextField.text else {return}
    BoardTableViewModel().postBoardwithName(nameOfBoard, color: nameOfSelectedColor) { [weak self] (result) in
      if let error = result{
        let alert = UIAlertController.alertWithError(error)
        self?.present(alert, animated: true) {}
      } else {
         self?.navigationController?.popViewController(animated: true)
      }
    }
  }
}

extension AddBoardViewController: UITextFieldDelegate {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard addBoard.isEnabled else {return false}
      createNewBoard(nil)
    return false
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    addBoard?.isEnabled = !(string.isEmpty && text.count == 1)
    return true
  }
}
