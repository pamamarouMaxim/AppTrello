//
//  CoreDataManager + Card.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/14/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

extension CoreDataManager{
  
  func getCardsFromList(withId id: String, comletion : @escaping (Error?) -> Void) {
    api.getCardsForListId(id) { [weak self](result) in
      switch result{
      case .success(let cards) :
        guard let context = self?.writeContext else {return}
        context.perform {
          let request = CardEntity.fetchRequest() as NSFetchRequest
          let predicate = NSPredicate(format: "parentList.id == %@", id)
          request.predicate = predicate
          do {
            let cardEntitys = try context.fetch(request)
            guard let listEntity = self?.getListEntity(WithId: id, context: context) else {return}
            for card in cards{
              let cardEntity = cardEntitys.filter({$0.id == card.id})
              if cardEntity.isEmpty{
                let newCardEntity = CardEntity(context: context, card: card)
                listEntity.addToCardsRelationship(newCardEntity)
              } else if let firstCardEntity = cardEntity.first{
                firstCardEntity.name = card.name
                firstCardEntity.dueComplete = card.dueComplete
              }
            }
            let cardEntitysId = cardEntitys.map({ (entity) -> String in
              guard let id = entity.id else {return ""}
              return id
            })
            let serverCardsId = cards.map({$0.id})
            let objectDifference = Set(cardEntitysId).subtracting(serverCardsId)
            for object in objectDifference{
              let cardEntity = cardEntitys.filter({$0.id == object})
              for entity in cardEntity{
                context.delete(entity)
              }
            }
            self?.save(Context: context)
            DispatchQueue.main.async {
               comletion(nil)
            }
          } catch {
            comletion(error)
          }
        }
      case .failure(let error) : comletion(error)
      }
    }
  }
  
  func  postNewCardFromList(withId id: String,  name : String, completion : @escaping (Error?)-> Void) {
    api.postNewCardForListId(id, nameOfCard: name) { [weak self](result) in
      switch result{
      case .success(let card) :
        guard let context = self?.writeContext else {return}
        context.perform {
          guard let listEntity = self?.getListEntity(WithId: id, context: context) else {return}
          let entityCard = CardEntity(context: context, card: card)
          listEntity.addToCardsRelationship(entityCard)
          self?.save(Context: context)
          DispatchQueue.main.async {
            completion(nil)
          }
        }
      case .failure(let error) : completion(error)
      }
    }
  }
  
  func getCardInfo(_ cardId: String, completion: @escaping (Any?) -> Void) {
    api.getCardInfo(cardId) { [weak self](result) in
      switch result {
      case .success(let cardInfo) :
        guard let context = self?.writeContext else {return}
        context.perform {
          let request = CardEntity.fetchRequest() as NSFetchRequest
          let predicate = NSPredicate(format: "id == %@", cardId)
          request.predicate = predicate
          do {
            let cardEntity = try context.fetch(request)
            if let first = cardEntity.first{
              first.attachments = cardInfo.attachments
              first.date = cardInfo.due
              first.desc = cardInfo.desc
              first.labels = cardInfo.labels
              if let imageUrl = first.imagesUrl{
                let objectDifference = Set(imageUrl).subtracting(cardInfo.attachments)
                let needRemoval = objectDifference.map({$0.imageFileName()})
                DispatchQueue.global(qos: .background ).async {
                  for imageName in needRemoval{
                     LocalImagesProvider.default.removeImage(fileName: imageName)
                  }
                }
                first.imagesUrl = cardInfo.attachments.map{$0.imageFileName()}
              } else {
                first.imagesUrl = cardInfo.attachments.map({$0.imageFileName()})
              }
              self?.save(Context: context)
              DispatchQueue.main.async {
                completion(first)
              }
            }
          } catch {
            completion(error)
          }
        }
      case .failure(let error): completion(error)
      }
    }
  }
  
  private func getListEntity(WithId listId: String, context : NSManagedObjectContext) -> ListEntity?{
     let fetchList = ListEntity.fetchRequest() as NSFetchRequest
     let predicate = NSPredicate(format: "id == %@", listId)
     fetchList.predicate = predicate
    do {
      let listEntity = try context.fetch(fetchList)
      if  let firstListEntity = listEntity.first{
        return firstListEntity
      }
    } catch {
      return nil
    }
    return nil
  }
}
