//
//  CardDescriptionViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/6/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class CardDescriptionViewController: UIViewController {

  @IBOutlet weak var descriptionTextView: UITextView!
  
  var cardDescriptionViewModel : CardDescriptionViewModel?
  
  override func viewDidLoad() {
        super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addDescription(_:)))
    descriptionTextView.text = cardDescriptionViewModel?.descriptionText
    }

  @objc func addDescription(_ sender : UIBarButtonItem){
    cardDescriptionViewModel?.postCardDescription(description: descriptionTextView.text, completion: { [weak self] (result) in
      if let error = result{
        let alert = UIAlertController.alertWithError(error)
        self?.present(alert,animated: true)
      } else {
        self?.navigationController?.popViewController(animated: true)
      }
    })
  }
}

extension CardDescriptionViewController : UITextViewDelegate{
  
  
}
