//
//  CardInfoTableViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/10/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class CardInfoTableViewController: UITableViewController {

  var cardViewModel : CardViewModel!
  
  private var imageView = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = UITableViewAutomaticDimension
    registerCells()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    startActivityIndicator()
    getDataForTableView()
  }
  
   override func numberOfSections(in tableView: UITableView) -> Int {
    guard let sections = cardViewModel.dataSourse?.numberOfSections() else {return 1}
    return sections
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let row = cardViewModel.dataSourse?.numberOfItems(in: section) else {return 1}
    return row
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let model = cardViewModel.dataSourse?.item(at: indexPath) as? BindableCellViewModel,
      let bindableCell = tableView.dequeueReusableCell(withIdentifier: model.cellClass.reuseIdentifier, for: indexPath) as? BindableCell
      else {
        return UITableViewCell()
    }
    bindableCell.setup(with: model)
    if let collectionCell = bindableCell as? CollectionTableViewCell{
      collectionCell.delegate = self
      return (bindableCell as? UITableViewCell) ?? UITableViewCell()
    }
    return (bindableCell as? UITableViewCell) ?? UITableViewCell()
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    
    guard let cell = tableView.cellForRow(at: indexPath) as? DescriptionCardTableViewCell else {return}
    let conrtoller = UIStoryboard(name: "List", bundle: Bundle.main ).instantiateViewController(withIdentifier: "CardDescriptionViewController") as? CardDescriptionViewController
    guard let cardDescriptionViewController = conrtoller else {return}
    guard  let text =  cell.textLabel?.text else {return}
    cardDescriptionViewController.cardDescriptionViewModel = CardDescriptionViewModel(api: ServerManager.default, card: cardViewModel.card, descriptionText: text)
    navigationController?.pushViewController(cardDescriptionViewController, animated: true)
  }
  
  private func getDataForTableView(){
      self.cardViewModel.getCardInfo {[weak self] (result) in
          if let error = result{
            let alert = UIAlertController.alertWithError(error)
            self?.present(alert,animated: true)
          }
          self?.cardViewModel.composeDataSource()
          if self?.tableView.tableHeaderView == nil{
            if let attachmentCount = self?.cardViewModel.cardEntity?.attachments?.count{
              if attachmentCount > 0{
                self?.addHeader(FromImageUrl: self?.cardViewModel.cardEntity?.attachments?.first)
              }
            }
          }
          self?.stopActivityIndicator()
          self?.tableView.reloadData()
      }
  }
  
  private func addHeader(FromImageUrl urlString : String?){
    if let urlString = urlString, let url = URL(string: urlString){
        self.cardViewModel.getImage(FromUrl: url, completion: { [weak self] (image) in
            guard let picture = image else {return}
            guard let height = self?.view.bounds.height else {return}
            let view = UIView(frame: CGRect(x: 0, y: 0,
                                            width: Int((self?.view.bounds.width)!),
                                            height: Int(height/3)))
            view.backgroundColor = picture.areaAverage()
            self?.imageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                        width:  view.bounds.width/2.5,
                                                        height: view.bounds.height))
            self?.imageView.center = view.center
            self?.imageView.image = picture
            view.addSubview((self?.imageView)!)
            self?.tableView.tableHeaderView = view
            self?.stopActivityIndicator()
            self?.tableView.reloadData()
        })
    }
  }
  
  private func registerCells(){
    tableView.register(UINib.init(nibName: "CardCellTableViewCell", bundle: nil),
                       forCellReuseIdentifier: "CardCellTableViewCellIdentifier")
    tableView.register(CollectionTableViewCell.self,
                       forCellReuseIdentifier: "CollectionTableViewCellIdentifier")
    tableView.register(HeaderCardTableViewCell.self,
                       forCellReuseIdentifier:  "HeaderCardTableViewCellIdentifier")
    tableView.register(DescriptionCardTableViewCell.self,
                       forCellReuseIdentifier: "DescriptionCardTableViewCellIdentifier")
  }
}
