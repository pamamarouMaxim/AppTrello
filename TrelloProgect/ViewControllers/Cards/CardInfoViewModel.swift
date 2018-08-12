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
  var images = [UIImage]()
  
  init(api : DetailCards, card : Card, rootList : BoardList) {
    self.api = api
    self.card = card
    self.rootList = rootList
  }
  
  func composeDataSource()  {
    
    guard let cardInfo = cardInfo else {return}
    
    //TODO: we should use different view models for different cells (1 cell view - 1 cell model)
    let headerCard = CellViewModel(cellClass: HeaderCardTableViewCell.self)
    headerCard.cardAndListNames = (card.name,rootList.name)
    
    let descriptionViewModel = CellViewModel(cellClass: DescriptionCardTableViewCell.self)
    descriptionViewModel.description = cardInfo.desc
    
    let dateViewModel = CellViewModel(cellClass: CardCellTableViewCell.self)
    dateViewModel.image = UIImage(named: "clock.png")
    dateViewModel.due = cardInfo.due
    
    let labelsViewModel = CellViewModel(cellClass: CardCellTableViewCell.self)
    labelsViewModel.image = UIImage(named : "Mark.png")
    
    let usersViewModel = CellViewModel(cellClass: CardCellTableViewCell.self)
    usersViewModel.image = UIImage(named: "user.png")
    
    dataSourse = ArrayDataSource(with: [[headerCard,descriptionViewModel],[dateViewModel,labelsViewModel,usersViewModel]])
    
    if cardInfo.attachments.count > 0{
      let collectionTableViewCell = CellViewModel(cellClass: CollectionTableViewCell.self)
      collectionTableViewCell.attachments = cardInfo.attachments
      dataSourse?.objects.append([collectionTableViewCell])
    }
  }
  
  func getCardInfo(completion:@escaping (Error?) -> Void) {
    api.getCardInfo(card.id) { [weak self](result) in
      switch result {
      case .success(let cardInfo) :
      self?.cardInfo = cardInfo
      completion(nil)
      case .failure(let error): completion(error)
      }
    }
  }
  
  func getImage(FromUrl url : URL, completion :(UIImage?) -> Void) {
    let data = try? Data(contentsOf: url)
    guard let imageData = data else {return}
    let picture = UIImage(data: imageData)
    if let image = picture{
      completion(image)
    }
    completion(nil)
  }
}
