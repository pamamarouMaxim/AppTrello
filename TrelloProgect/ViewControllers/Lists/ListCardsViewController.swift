//
//  ListViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/29/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit
import CoreData

class ListCardsViewController: UIViewController,NSFetchedResultsControllerDelegate {

  var listCardsViewModel : ListCardsViewModel!
  
  @IBOutlet weak var cardTableView: UITableView!
  @IBOutlet weak var addCardButton: UIButton!
  @IBOutlet weak var nameCardLabel: UILabel!
  @IBOutlet weak var baseView: UIView!
 
  let coreDataManager = CoreDataManager()
  lazy var persistentContainer = coreDataManager.persistentContainer
  
  fileprivate lazy var fetchedResultsController: NSFetchedResultsController<CardEntity> = {
    let fetchRequest: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
    let predicate = NSPredicate(format: "parentList.id == %@", listCardsViewModel.bordList.id)
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dueComplete", ascending: true)]
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataManager.readContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    return fetchedResultsController
  }()
  
  override func viewDidLoad() {
      super.viewDidLoad()
    startActivityIndicator()
    nameCardLabel.text = listCardsViewModel.bordList.name
    getAllCards()
  }
  
  @IBAction func tapAddButton(_ sender: UIButton) {
    showAlertForNewCard()
  }
  
  private func getAllCards(){
    self.listCardsViewModel.getCardsFromListWithId { [weak self](error) in
        if let error = error{
          let alert = UIAlertController.alertWithError(error)
          self?.present(alert, animated: true)
        }
        self?.executeFetchRequest()
        self?.stopActivityIndicator()
    }
  }
  
  private func executeFetchRequest(){
    do {
      try fetchedResultsController.performFetch()
    } catch (let error){
      let alert = UIAlertController.alertWithError(error)
      self.present(alert, animated: true)
    }
    newHeightTableView()
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
              do {
                try self?.fetchedResultsController.performFetch()
              } catch {
                
              }
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
    return  2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    guard let fetchController = fetchedResultsController.fetchedObjects else {return 0}
    switch section {
    case 0: return fetchController.filter({ $0.dueComplete == false}).count
    case 1: return fetchController.filter({ $0.dueComplete == true}).count
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
      guard let cardCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CardTableViewCell else
      {return UITableViewCell()}
      guard let fetchController = fetchedResultsController.fetchedObjects else {return UITableViewCell()}
    var card  = CardEntity()
    var dueComplete = Bool()
    if indexPath.section == 0{
      dueComplete  = false
    } else {
       dueComplete = true
    }
    let count = fetchController.filter({ $0.dueComplete == dueComplete}).count
    if  count > 0{
      card = fetchController.filter({ $0.dueComplete == dueComplete})[indexPath.row]
      cardCell.cardNameLable.text = card.name
      cardCell.cardId = card.id
        return cardCell
      }
    return UITableViewCell()
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
    let card = fetchedResultsController.object(at: indexPath)
    guard let id = card.id,let name = card.name else {return}
    let value = Card(id: id, name: name, dueComplete: card.dueComplete)
    let  cardViewModel = CardViewModel(api: ServerManager.default, card: value,rootList: listCardsViewModel.bordList)
    let controller = UIStoryboard(name: "List", bundle: nil).instantiateViewController(withIdentifier: "CardInfoTableViewController") as? CardInfoTableViewController
    guard let cardTableViewController = controller else {return}
    cardTableViewController.cardViewModel = cardViewModel
    tableView.deselectRow(at: indexPath, animated: false)
    navigationController?.pushViewController(cardTableViewController, animated: true)
  }
}
