//
//  CardViewModel.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/2/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import SwiftyJSON

class CardViewModel {
  
  let api  : DetailCards
  let card : Card
  let rootList : BoardList
  var dataSourse : ArrayDataSource?
  var cardInfo : CardInfo?
  
  init(api : DetailCards, card : Card, rootList : BoardList) {
    self.api = api
    self.card = card
    self.rootList = rootList
  }
  
  func data()  {
    let cell1 = test()
    let cell2 = infoCell()
    let  cell3 = descriptionCell()
    let cell4 = collection()
    dataSourse = ArrayDataSource(with: [cell1,cell2,cell3,cell4])
  }
  
  func collection() -> UITableViewCell {
    
    let cell = Bundle.main.loadNibNamed("CollectionViewTableViewCell", owner: CardTableViewController.self, options: nil)?.first as? CollectionViewTableViewCell
    
    cell?.contentView.backgroundColor = UIColor.blue
    
   return  cell!
  }
  
  func test() -> UITableViewCell {
    let nameCardCell = UITableViewCell(style: .subtitle, reuseIdentifier: "NameCardCell")
    nameCardCell.textLabel?.text = card.name
    nameCardCell.detailTextLabel?.text = "In list:  " + rootList.name
    nameCardCell.textLabel?.textColor = UIColor.white
    nameCardCell.detailTextLabel?.textColor = UIColor.white
    nameCardCell.contentView.backgroundColor = UIColor.blue
    return nameCardCell
  }
  
  func descriptionCell() -> UITableViewCell {
    let descriptionCell = UITableViewCell(style: .value1, reuseIdentifier: "DescriptionCell")
    descriptionCell.textLabel?.numberOfLines = 0
    descriptionCell.textLabel?.text = "touch to add a description"
    descriptionCell.textLabel?.textColor = UIColor.lightGray
    return descriptionCell
  }
  
  func infoCell() -> UITableViewCell {
    
    let cardCell = Bundle.main.loadNibNamed("CardCellTableViewCell", owner: CardTableViewController.self, options: nil)?.first as? CardCellTableViewCell
  
    guard let cell = cardCell else {return UITableViewCell()}
   
    cell.cellImage.image =  UIImage(named: "clock.png")
   
      
      cell.cellLabel.text = "eeeeee!!!!"

    return cell
  }
  
  func getCardInfo(completion:@escaping (Error?) -> Void) {
    api.getCardInfo(card.id) { [weak self](result) in
     var labelsColor = [String]()
      var attachmentsUrl = [String]()
      switch result {
      case .success(let success) : let data = JSON(success).dictionaryObject
      guard let cardDetail = data else {return}
      guard let cardDue = cardDetail["due"] as? String? else {return}
      guard let cardDescription = cardDetail["desc"] as? String? else {return}
      guard let cardLabels = cardDetail["labels"] as? [Dictionary<String,String>] else {return}
      for label in cardLabels{
        guard let color = label["color"] else {return}
        labelsColor.append(color)
        }
      guard let attachments = cardDetail["attachments"] as? [Dictionary<String,Any>] else {return}
      for attachment in attachments{
        guard let previews = attachment["previews"] as? [Dictionary<String,Any>] else {return}
        guard let last = previews.last as? [String:Any] else {return}
        guard var attachmentUrl = last["url"]  as? String else {return}
        attachmentsUrl.append(attachmentUrl)
        }
      guard let date = cardDue, let description = cardDescription else {return}
      //self?.cardInfo = CardInfo(date: date, description: description, labels: labelsColor, attachments: attachmentsUrl)
      if attachmentsUrl.count > 0{
        for value in attachmentsUrl{
         
          self?.getImageAttachments(url: value , completion: { (result) in
            
          })
        }
       
        }
      case .failure(_): completion(nil)
      }
    }
  }
  
  private func getImageAttachments(url : String, completion:@escaping (Error?) -> Void) {
    
    api.getImageAttachmentUrl(url) { (result) in
      
    }
  }
}
