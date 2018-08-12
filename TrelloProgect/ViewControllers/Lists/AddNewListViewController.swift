//
//  AddNewListViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/1/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class AddNewListViewController: UIViewController {

  @IBOutlet weak var addNewListTextField: UITextField!
  
  var addListViewModel : AddListViewModel!
  var onListAdded: ((BoardList) -> Void)?
  
  override func viewDidLoad() {
        super.viewDidLoad()
    view.backgroundColor = addListViewModel.rootBoard.backgroundColor
    }
}

extension AddNewListViewController : UITextFieldDelegate{
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text?.isEmpty else {return false}
    if text{
       textField.resignFirstResponder()
       return false
    }
    guard let name = textField.text else {return false}
    addListViewModel.postNewListWithName(name) { [weak self](result) in
//      switch result{
//      case .success(let list):
//        if let completion = self?.onListAdded{
//           completion(list)
//        }
//      case .failure(let error):
//        let alert = UIAlertController.alertWithError(error)
//        self?.present(alert,animated: true)
//      }
    }
    textField.text = ""
    textField.resignFirstResponder()
    return true
  }
}
