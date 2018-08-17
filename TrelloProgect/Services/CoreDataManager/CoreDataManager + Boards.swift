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
        context.perform {
          let request = BoardEntity.fetchRequest() as NSFetchRequest
          do {
            let boardsEntitys = try context.fetch(request)
            for board in boards{
              let boardEntity = boardsEntitys.filter({$0.id == board.id})
              if boardEntity.isEmpty{
                _ = BoardEntity(context: context, board: board)
              } else if let firstBoardEntity = boardEntity.first{
                firstBoardEntity.name = board.name
              }
            }
            let boardsEntitysId = boardsEntitys.map({ (entity) -> String in
              guard let id = entity.id else {return ""}
              return id
            })
            let serverBoardId = boards.map({$0.id})
            let objectDifference = Set(boardsEntitysId).subtracting(serverBoardId)
            for object in objectDifference{
              let boardEntity = boardsEntitys.filter({$0.id == object})
              for entity in boardEntity{
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

      case .failure(let error): completion(error)
      }
    }
  }
  
  func postBoard(withName name : String, color : String , completion: @escaping (Error?)  -> Void )  {
    api.postBoardwithName(name, color: color) {[weak self](response) in
      switch response{
      case .success(let board) :
        guard let context = self?.writeContext else {return}
        context.perform {
          _  = BoardEntity(context: context, board: board)
           self?.save(Context: context)
          DispatchQueue.main.async {
            completion(nil)
          }
        }
      case .failure(let error) : completion(error)
      }
    }
  }
  private func getOrCreateBoadEntity(){
  }
}
