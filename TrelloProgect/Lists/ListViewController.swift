//
//  ListViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/29/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

  //TODO: move to viewModel
  var listOfBoard : ListOfBoard?
  var colorOfBoard: UIColor?
  
  
  var cardViewModel  = CardViewModel() //TODO: ListViewModel
  
  @IBOutlet weak var cardTableView: UITableView!

  override func viewDidLoad() {
      super.viewDidLoad()
    cardTableView.backgroundColor = colorOfBoard
    cardTableView.isOpaque = false
    cardTableView.backgroundView = nil
    listOfBoard = ListOfBoard(id: "5b5f8a05a1afb8ebe9d8a239", name: "name")
    cardViewModel.getCardsFromListWithId((listOfBoard?.id)!) { (result) in
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    cardTableView.estimatedRowHeight = 20
    cardTableView.rowHeight = UITableViewAutomaticDimension
    guard let idOfList = listOfBoard?.id else {return}
    cardViewModel.getCardsFromListWithId(idOfList) { [weak self](result) in
      
      self?.cardTableView.reloadData()
    }
  }
}

extension ListViewController : UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int{
    
    guard let sectons = cardViewModel.cards?.numberOfSections() else {return 0}
    
    
    return sectons + 2 //TODO: make table view header and footer
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    if cardViewModel.cards?.numberOfItems != nil{
      switch section {
      case 0,3: return 1
      default:   guard let rows = cardViewModel.cards?.numberOfItems(in: section - 1) else {return 0}
      return rows
      }
    } else {
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    if  indexPath.section == 0{
      let cell = (tableView.dequeueReusableCell(withIdentifier: "Cell") as? CardTableViewCell)!
      guard let name = listOfBoard?.name else {return UITableViewCell()}
      cell.textForCard.text = name
      cell.textForCard.isEditable = false
      cell.textForCard.backgroundColor = UIColor.gray
      cell.backgroundColor = UIColor.gray
      return cell
    } else if  indexPath.section == 3{
      let cardCell = (tableView.dequeueReusableCell(withIdentifier: "Cell") as? CardTableViewCell)!
      cardCell.textForCard.text = "Add new card"
      cardCell.textForCard.textAlignment = NSTextAlignment.center
      cardCell.textForCard.isEditable = false
      cardCell.textForCard.backgroundColor = UIColor.gray
      cardCell.backgroundColor = UIColor.gray
      return cardCell
    } else {
      let cardCell = (tableView.dequeueReusableCell(withIdentifier: "Cell") as? CardTableViewCell)!
      guard let object = cardViewModel.cards?.item(at: IndexPath(row: indexPath.row, section: indexPath.section - 1))
        else {return UITableViewCell()}
      guard let card = object as? Cards else {return UITableViewCell()}
      cardCell.textForCard.text = card.name
      cardCell.textForCard.isEditable = false
      return cardCell
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
    switch section {
    case   1: return "To do"
    case   2: return "Done"
    case   0,3: return ""
    default:  return ""
    }
  }
}

extension ListViewController : UITableViewDelegate{
  
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 3{
      showAlertForNewCard()
//      arrayOfCards.append("hello")
//      tableView.beginUpdates()
//      tableView.insertRows(at: [IndexPath(row: arrayOfCards.count + 1, section: 1)], with: .left)
//      tableView.endUpdates()
    }
     tableView.deselectRow(at: indexPath, animated: false)
  }
  
  private func showAlertForNewCard(){
    let alert = UIAlertController(title: "Create a new card", message: "Name", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in }))
    alert.addTextField { (textField) in
      textField.text = ""
    }
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_) in
      if alert.textFields?.first?.text != ""{
        self?.cardViewModel.postNewCardWithName((alert.textFields?.first?.text)!, completion: { (result) in
          
        })
      }
    }))
    self.present(alert, animated: true, completion: nil)
  }
}


