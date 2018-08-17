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
        context.perform {
          let request = ListEntity.fetchRequest() as NSFetchRequest
          let predicate = NSPredicate(format: "parentBoard.id == %@", id)
          request.predicate = predicate
          do {
            let listEntitys = try  context.fetch(request)
            guard let boardEntity = self?.getBoardEntity(WithId: id, context: context) else {return}
             for list in lists{
                let listEntity = listEntitys.filter({$0.id == list.id})
                if listEntity.isEmpty{
                  let newListEntity = ListEntity(context: context, list: list)
                  boardEntity.addToLists(newListEntity)
                } else if let firstListEntity = listEntity.first{
                firstListEntity.name = list.name
                }
            }
              let listsEntitysId = listEntitys.map({ (entity) -> String in
              guard let id = entity.id else {return ""}
              return id
              })
              let serverListsId = lists.map({$0.id})
              let objectDifference = Set(listsEntitysId).subtracting(serverListsId)
              for object in objectDifference{
                let listEntity = listEntitys.filter({$0.id == object})
                for entity in listEntity{
                    context.delete(entity)
                }
              }
            self?.save(Context: context)
            DispatchQueue.main.async {
               completion(nil)
            }
          } catch {
            completion(error)
          }
        }
      case .failure(let error)   : completion(error)
      }
    }
  }
  
  func  postNewList(withName name : String,boardId : String,completion : @escaping (Any?) -> Void) {
    api.makeNewListInBoard(boardId, nameList: name) { [weak self](result) in
      switch result{
      case .success(let list) :
        guard let context = self?.writeContext else {return}
        context.perform {
          guard let board = self?.getBoardEntity(WithId: boardId, context: context) else {return}
          let list = ListEntity(context: context, list: list)
          board.addToLists(list)
          self?.save(Context: context)
          DispatchQueue.main.async {
            completion(list)
          }
        }
      case .failure(let error) : completion(error)
      }
    }
  }
  
  private func getBoardEntity(WithId boardId: String, context : NSManagedObjectContext) -> BoardEntity?{
    let fetchBoard = BoardEntity.fetchRequest() as NSFetchRequest
    let predicate = NSPredicate(format: "id == %@", boardId)
    fetchBoard.predicate = predicate
    do {
      let boardEntity = try context.fetch(fetchBoard)
      if let firstEntity = boardEntity.first{
        return firstEntity
      }
    } catch{
      return nil
    }
    return nil
  }
}
