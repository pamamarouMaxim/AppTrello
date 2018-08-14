//
//  CoreDataManager + Boards.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/14/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

extension CoreDataManager{
  
  func getAllBoardWithComplitionBlock(_ completion : @escaping (Error?) -> Void) {
    api.getAllBoardWithBlock { [weak self](response) in
      switch response{
      case .success(let boards):
        guard let context = self?.writeContext else {return}
//        context.perform {
//          1. fetch all boards
//          2. diff
//          3. remove from fetched boards boards with deleted ids
//          4. use getOrCreate method to create or update board
//          5. save context
//        }
        var contextBoardId = [String]()
        let request = BoardEntity.fetchRequest() as NSFetchRequest
        do {
          let boardEntitys = try  context.fetch(request)
          contextBoardId = boardEntitys.map({$0.id!})
        } catch {
          completion(error)
        }
        let serverBoardsId = boards.map({$0.id})
        let diffrence = differenceArrays(contextBoardId, serverBoardsId, with: { (a, b) -> Bool in
          return a == b
        })
        //  removed
        for removedBoardId in diffrence.removed {
          let predicate = NSPredicate(format: "id == %@", removedBoardId)
          request.predicate = predicate
          do {
            let boardEntitys = try context.fetch(request)
            for entity in boardEntitys{
              context.delete(entity)
            }
          } catch {
            completion(nil)
          }
        }
        // insert
//        let boardEntity = BoardEntity(context: context) //NSEntityDescription.entity(forEntityName: "BoardEntity", in: context)
//      //  let boardEntity = entity
//        for insertBoardId in diffrence.inserted {
//          let board = boards.filter{$0.id == insertBoardId}
//          guard let first = board.first else {return}
//          _ = BoardEntity(entity: boardEntity, insertInto: context, board: first)
//        }
        self?.saveContext()
        completion(nil)
      case .failure(let error): completion(error)
      }
    }
  }
  
  func postBoard(withName name : String, color : String , completion: @escaping (Error?)  -> Void )  {
    api.postBoardwithName(name, color: color) {[weak self](response) in
      switch response{
      case .success(let board) :
        // TODO: insert in perform block
        guard let context = self?.writeContext else {return}
        let entity = NSEntityDescription.entity(forEntityName: "BoardEntity", in: context)
        guard let boardEntity = entity else {return}
        _ = BoardEntity(entity: boardEntity, insertInto: context, board: board)
        self?.saveContext()
        completion(nil)
      case .failure(let error) : completion(error)
      }
    }
  }
}
