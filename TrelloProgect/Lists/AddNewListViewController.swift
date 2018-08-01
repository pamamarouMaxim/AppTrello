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
  override func viewDidLoad() {
        super.viewDidLoad()
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
    
    addListViewModel.postListName(name) { [weak self](result) in
      if let list = result{
        let controller = UIStoryboard(name: "Boards", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListCardsViewController") as? ListCardsViewController
        controller?.listCardsViewModel = ListCardsViewModel(bordList:list)
        controller?.view.backgroundColor = self?.addListViewModel.rootBoard.backgroundColor
        textField.text = ""
        textField.resignFirstResponder()
        NotificationCenter.default.post(name: .AddedNewListOnBoard, object: controller, userInfo: nil)
      }
    }
    return true
  }
}


