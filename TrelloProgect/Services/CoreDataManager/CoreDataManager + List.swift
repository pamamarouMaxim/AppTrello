//
//  CoreDataManager + List.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/14/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

extension CoreDataManager{
  
  func getListsFromBoard(_ id : String, completion : @escaping (Error?) -> Void)  {
    api.getListsForBoard(id) { [weak self](response) in
      switch response{
      case .success(let lists) :
        guard let context = self?.writeContext else {return}
        let request = ListEntity.fetchRequest() as NSFetchRequest
        var entitys = [String]()
        do {
          let listEntitys = try  context.fetch(request)
          entitys = listEntitys.map({$0.id!})
        } catch {
          completion(error)
        }
        let diffrence = differenceArrays(entitys, lists.map({$0.id}), with: { (a, b) -> Bool in
          return a == b
        })
        for removedList in diffrence.removed {
          let predicate = NSPredicate(format: "id == %@", removedList)
          request.predicate = predicate
          do {
            let listEntitys = try  context.fetch(request)
            for entity in listEntitys{
              context.delete(entity)
            }
          } catch {
            completion(nil)
          }
        }
        let entity = NSEntityDescription.entity(forEntityName: "ListEntity", in: context)
        guard let listEntity = entity else {return}
        if diffrence.inserted.count > 0{
          var newListsEntity = [ListEntity]()
          for insertListId in diffrence.inserted {
            let list = lists.filter{$0.id == insertListId}
            guard let first = list.first else {return}
            let newEntity =  ListEntity(entity: listEntity, insertInto: context, list: first)
            newListsEntity.append(newEntity)
          }
          let boardRequest = BoardEntity.fetchRequest() as NSFetchRequest
          let predicate = NSPredicate(format: "id == %@", id)
          boardRequest.predicate = predicate
          do {
            let board = try context.fetch(boardRequest)
            if let first = board.first{
              first.addToLists(NSSet(array:newListsEntity))
            }
          } catch {
            completion(error)
          }
        }
        self?.saveContext()
        completion(nil)
      case .failure(let error)   : completion(error)
      }
    }
  }
  
  func   postNewList(withName name : String,boardId : String,completion : @escaping (Any?) -> Void) {
    api.makeNewListInBoard(boardId, nameList: name) { [weak self](result) in
      switch result{
      case .success(let list) :
        guard let context = self?.writeContext else {return}
        let entity = NSEntityDescription.entity(forEntityName: "ListEntity", in: context)
        guard let listEntity = entity else {return}
        let list = ListEntity(entity: listEntity, insertInto: context, list: list)
        let request = BoardEntity.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "id == %@", boardId)
        request.predicate = predicate
        do {
          let board = try  context.fetch(request)
          if let first = board.first{
            first.addToLists(list)
          }
        } catch {
          completion(list)
        }
        self?.saveContext()
        if let id = list.id,let name = list.name{
          completion(BoardList(id: id, name: name))
        }
        completion(nil)
      case .failure(let error) : completion(error)
      }
    }
  }
  
  
}
