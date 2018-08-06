//
//  ListViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/29/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class ListCardsViewController: UIViewController {

  var listCardsViewModel : ListCardsViewModel!
  
  @IBOutlet weak var cardTableView: UITableView!
  @IBOutlet weak var addCardButton: UIButton!
  @IBOutlet weak var nameCardLabel: UILabel!
  @IBOutlet weak var baseView: UIView!
 
  override func viewDidLoad() {
      super.viewDidLoad()
    nameCardLabel.text = listCardsViewModel.bordList.name
    getAllCards()
  }
  
  @IBAction func tapAddButton(_ sender: UIButton) {
    showAlertForNewCard()
  }
  
  private func getAllCards(){
    listCardsViewModel.getCardsFromListWithId { [weak self](error) in
    self?.newHeightTableView()
    }
  }
  
  private func showAlertForNewCard(){
    
    let alert = UIAlertController(title: "Create a new card", message: "Name", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in }))
    alert.addTextField { (textField) in
      textField.text = ""
    }
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_) in
      if alert.textFields?.first?.text != ""{
        self?.listCardsViewModel.postNewCardWithName((alert.textFields?.first?.text)!, completion: { (result) in
          if let error = result{
            let alert = UIAlertController.alertWithError(error)
            self?.present(alert, animated: true) {}
          } else {
              self?.newHeightTableView()
          }
        })
      }
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  private func newHeightTableView()  {
    for constraints in self.cardTableView.constraints{
      if constraints.identifier ==  "CardTableViewConstraintHeight"{
        let maxHeight = view.bounds.height
        let tableViewHeight = getTableViewHeight()
        if tableViewHeight > maxHeight *  0.7{
          constraints.constant = maxHeight * 0.7
        } else {
          constraints.constant = tableViewHeight
        }
      }
    }
  }
  
  private func getTableViewHeight()->CGFloat{
    cardTableView.reloadData()
    return cardTableView.contentSize.height + cardTableView.contentInset.bottom + cardTableView.contentInset.top
  }
}

extension ListCardsViewController : UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int{
    guard let sectons = listCardsViewModel.cardsDataSource?.numberOfSections() else {return 0}
    return sectons
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    if listCardsViewModel.cardsDataSource?.numberOfItems != nil{
     guard let rows = listCardsViewModel.cardsDataSource?.numberOfItems(in: section) else {return 0}
      return rows
      }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
      guard let cardCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CardTableViewCell else
      {return UITableViewCell()}
      guard let object = listCardsViewModel.cardsDataSource?.item(at: IndexPath(row: indexPath.row, section: indexPath.section ))
      else {return UITableViewCell()}
      guard let card = object as? Card else {return UITableViewCell()}
      cardCell.cardNameLable.text = card.name
      cardCell.cardId = card.id
      return cardCell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
    switch section {
    case   0: return "To do"
    case   1: return "Done"
    default:  return ""
    }
  }
}

extension ListCardsViewController : UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let card = listCardsViewModel.cardsDataSource?.item(at: indexPath) as? Card else {return}
    let  cardViewModel = CardViewModel(api: ServerManager.default, card: card,rootList: listCardsViewModel.bordList)
    let controller = UIStoryboard(name: "List", bundle: nil).instantiateViewController(withIdentifier: "CardTableViewController") as? CardTableViewController
    guard let cardTableViewController = controller else {return}
    cardTableViewController.cardViewModel = cardViewModel
    tableView.deselectRow(at: indexPath, animated: false)
    navigationController?.pushViewController(cardTableViewController, animated: true)
  }
}
