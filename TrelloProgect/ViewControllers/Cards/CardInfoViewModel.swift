//
//  CardViewModel.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/2/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class CardViewModel {
  
  let api  : DetailCards
  let card : Card
  let rootList : BoardList
  var dataSourse : ArrayDataSource?
  var cardEntity : CardEntity?
  var images = [UIImage]()
  let coreDataManager = CoreDataManager.default
  
  init(api : DetailCards, card : Card, rootList : BoardList) {
    self.api = api
    self.card = card
    self.rootList = rootList
  }
  
  func composeDataSource()  {
    
    guard let cardEntity = cardEntity else {return}
    
    //TODO: we should use different view models for different cells (1 cell view - 1 cell model)
    let headerCard = HeaderCardTableViewCellViewModel.init(cellClass: HeaderCardTableViewCell.self)
    headerCard.cardInfo = cardEntity
    headerCard.cardAndListNames = (card.name,rootList.name)
    
    let descriptionViewModel = DescriptionCardTableViewCellViewModel(cellClass: DescriptionCardTableViewCell.self)
    descriptionViewModel.cardInfo = cardEntity
    
    let dateViewModel = CardCellTableViewCellViewModel(cellClass: CardCellTableViewCell.self)
    dateViewModel.image = UIImage(named: "clock.png")
    dateViewModel.cardInfo = cardEntity
    
    let labelsViewModel = CardCellTableViewCellViewModel(cellClass: CardCellTableViewCell.self)
    labelsViewModel.image = UIImage(named : "Mark.png")
    
    let usersViewModel = CardCellTableViewCellViewModel(cellClass: CardCellTableViewCell.self)
    usersViewModel.image = UIImage(named: "user.png")
    
    dataSourse = ArrayDataSource(with: [[headerCard,descriptionViewModel],[dateViewModel,labelsViewModel,usersViewModel]])
    
    guard let attachmentCount = cardEntity.attachments?.count else {return}
    if attachmentCount > 0{
      let collectionTableViewCell = CollectionTableViewCellViewModel(cellClass: CollectionTableViewCell.self)
      collectionTableViewCell.cardInfo = cardEntity
      dataSourse?.objects.append([collectionTableViewCell])
    }
  }
  
  func getCardInfo(completion:@escaping (Error?) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
      self.coreDataManager.getCardInfo(self.card.id) {[weak self] (result) in
        DispatchQueue.main.async {
          if let cardEntity = result as? CardEntity{
            self?.cardEntity = cardEntity
            completion(nil)
          } else if let error = result as? Error{
            self?.getCardEntity()
            completion(error)
          }
        }
      }
    }
  }
  
  private func getCardEntity(){
    let context = coreDataManager.readContext
    let request = CardEntity.fetchRequest() as NSFetchRequest
    let predicate = NSPredicate(format: "id == %@", card.id)
    request.predicate = predicate
    do {
      let entity = try context.fetch(request)
      if let first = entity.first{
         cardEntity = first
      }
    } catch {
    }
  }
  
  func getImage(FromUrl url : URL, completion :@escaping (UIImage?) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
       let object = LocalImagesProvider.default
      object.getImage(FromUrl: url) { (image) in
        DispatchQueue.main.async {
          completion(image)
        }
      }
    }
  }
}
