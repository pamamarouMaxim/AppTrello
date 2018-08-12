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
    //tableView.rowHeight = UITableViewAutomaticDimension
    registerCells()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBlurButton(_:)))
    imageView.addGestureRecognizer(tapGesture)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    startActivityIndicator()
    getDataForTableView()
  }
  
  @objc func tapBlurButton(_ sender: UITapGestureRecognizer){
    
    //    let location : CGPoint = sender.location(in: self.view)
    //    let view =  self.view.hitTest(location, with: nil)
    //
    //    guard let controller = UIStoryboard(name: "List", bundle: nil).instantiateViewController(withIdentifier: "CardImageViewController") as? CardImageViewController else {return}
    //    controller.image = imageView.image
    //    navigationController?.pushViewController(controller, animated: true)
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
    return (bindableCell as? UITableViewCell) ?? UITableViewCell()
  }

  
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 300
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
    DispatchQueue.global(qos: .userInteractive).async {
      self.cardViewModel.getCardInfo {[weak self] (result) in
        self?.cardViewModel.composeDataSource()
        DispatchQueue.main.async {
          if let error = result{
            let alert = UIAlertController.alertWithError(error)
            self?.present(alert,animated: true)
          } else {
            if self?.tableView.tableHeaderView == nil{
              if let attachmentCount = self?.cardViewModel.cardInfo?.attachments.count{
                if attachmentCount > 0{
                   self?.addHeader(FromImageUrl: self?.cardViewModel.cardInfo?.attachments.first)
                } else {
                  self?.stopActivityIndicator()
                  self?.tableView.reloadData()
                }
              }
            } else {
              self?.stopActivityIndicator()
              self?.tableView.reloadData()
            }
          }
        }
      }
    }
  }
  
  private func addHeader(FromImageUrl urlString : String?){
    if let urlString = urlString, let url = URL(string: urlString){
      DispatchQueue.global().async {
        self.cardViewModel.getImage(FromUrl: url, completion: { [weak self] (image) in
         DispatchQueue.main.async {
            guard let picture = image else {return}
            guard let height = self?.view.bounds.height else {return}
            self?.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: height/3))
            self?.imageView.image = picture
            self?.tableView.tableHeaderView = self?.imageView
            self?.stopActivityIndicator()
            self?.tableView.reloadData()
          }
        })
      }
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
