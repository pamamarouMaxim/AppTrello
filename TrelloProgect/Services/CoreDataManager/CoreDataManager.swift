//
//  CoreDataManager.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/6/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class CoreDataManager {
  
  static let `default` = CoreDataManager()
  
  let api  =  ServerManager.default
  
 lazy var readContext :  NSManagedObjectContext = {
    let context =  NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.parent = persistentContainer.viewContext
    return context
  }()
  
  lazy var writeContext : NSManagedObjectContext = {
    let context =  NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    context.parent = persistentContainer.viewContext
    return context
  }()
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "TrelloProgect")
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  func save(Context context: NSManagedObjectContext){
    if context.hasChanges{
      do {
        try context.save()
        if let parentContext = context.parent{
          if parentContext.hasChanges{
            save(Context: parentContext)
          }
        }
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  func putCardsId(_ cardId: String, description : String, completion : @escaping (Any?) -> Void){
    api.putCardsId(cardId, description: description) { (result) in
    }
    
  }
}
