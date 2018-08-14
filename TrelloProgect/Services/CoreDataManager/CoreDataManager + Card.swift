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
        let requestCard = CardEntity.fetchRequest() as NSFetchRequest
        var cardEntitys = [String]()
        do {
          let cards = try context.fetch(requestCard)
          cardEntitys = cards.map({$0.id!})
        } catch {
          comletion(error)
        }
        
        let difference = differenceArrays(cardEntitys, cards.map({$0.id}), with: { (a, b) -> Bool in
          return a == b
        })
        
        for value in difference.removed{
          let predicate = NSPredicate(format: "id == %@", value)
          requestCard.predicate = predicate
          do {
            let cards = try context.fetch(requestCard)
            for card in cards{
              context.delete(card)
            }
          } catch {
            comletion(error)
          }
        }
        
        if difference.inserted.count > 0{
          let entity = NSEntityDescription.entity(forEntityName: "CardEntity", in: context)
          guard let cardEntity = entity else {return}
          var cardsEntity = [CardEntity]()
          for value in difference.inserted{
            let card = cards.filter{$0.id == value}
            for number in card{
              let newCardEntity = CardEntity(entity: cardEntity, insertInto: context, card: number)
              cardsEntity.append(newCardEntity)
            }
          }
          
          let listRequest = ListEntity.fetchRequest() as NSFetchRequest
          let predicate = NSPredicate(format: "id == %@", id)
          listRequest.predicate = predicate
          do {
            let list = try context.fetch(listRequest)
            if let first = list.first{
              first.addToCardsRelationship(NSSet(array: cardsEntity))
            }
          } catch (let error){
            comletion(error)
          }
        }
        self?.saveContext()
        comletion(nil)
      case .failure(let error) : comletion(error)
      }
    }
  }
  
  func  postNewCardFromList(withId id: String,  name : String, completion : @escaping (Error?)-> Void) {
    api.postNewCardForListId(id, nameOfCard: name) { [weak self](result) in
      switch result{
      case .success(let card) :
        guard let context = self?.writeContext else {return}
        let entity = NSEntityDescription.entity(forEntityName: "CardEntity", in: context)
        guard let cardEntity = entity else {return}
        let entityCard = CardEntity(entity: cardEntity, insertInto: context, card: card)
        let request = ListEntity.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "id == %@", id)
        request.predicate = predicate
        do {
          let result = try context.fetch(request)
          if let listEntity = result.first{
            listEntity.addToCardsRelationship(entityCard)
          }
        } catch {
          
        }
        self?.saveContext()
        completion(nil)
      case .failure(let error) : completion(error)
      }
    }
  }
  
  func getCardInfo(_ cardId: String, completion: @escaping (Any?) -> Void) {
    api.getCardInfo(cardId) { [weak self](result) in
      switch result {
      case .success(let cardInfo) :
        guard let context = self?.writeContext else {return}
        let request = CardEntity.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "id == %@", cardId)
        request.predicate = predicate
        do {
          let cardEntity = try context.fetch(request)
          if let first = cardEntity.first{
            first.attachments = cardInfo.attachments
            first.date = cardInfo.due
            first.desc = cardId.description
            first.labels = cardInfo.labels
            var imagesUrl = [String]()
            for attachment in cardInfo.attachments{
              imagesUrl.append(attachment.imageFileName())
            }
            first.imagesUrl = imagesUrl
            self?.saveContext()
            completion(first)
          }
        } catch {
          completion(error)
        }
        completion(nil)
      case .failure(let error): completion(error)
      }
    }
  }
}
