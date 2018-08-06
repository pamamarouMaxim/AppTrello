//
//  AppDelegate.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/24/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    choiceOfStartingStoryboard()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
  }

  func applicationWillTerminate(_ application: UIApplication) {
   
    self.saveContext()
  }
 
  lazy var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
      */
      let container = NSPersistentContainer(name: "TrelloProgect")
      container.loadPersistentStores(completionHandler: { (_, error) in
          if let error = error as NSError? {
            
              /*
               Typical reasons for an error here include:
               * The parent directory does not exist, cannot be created, or disallows writing.
               * The persistent store is not accessible, due to permissions or data protection when the device is locked.
               * The device is out of space.
               * The store could not be migrated to the current model version.
               Check the error message to determine what the actual problem was.
               */
              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()

  // MARK: - Core Data Saving support

  func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
          do {
              try context.save()
          } catch {
            
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
  }
}


extension AppDelegate {
  
  enum Autorization : String {
    
    case beforAutorizationViewController = "BeforeNavigationController"
    case afterAutorizationViewController = "AfterNavigationController"
    
    func storyBoardForAutorization() -> String {
      switch self {
      case .beforAutorizationViewController: return "Main"
      case .afterAutorizationViewController: return "Boards"
      }
    }
  }
  
  private func choiceOfStartingStoryboard(){
    
    var nameOfStoryBoard = String()
    var identifireViewController = String()
    
    if let _ = UserSettings.default.token,let _ = UserSettings.default.member{
      identifireViewController = Autorization.afterAutorizationViewController.rawValue
      nameOfStoryBoard = Autorization.afterAutorizationViewController.storyBoardForAutorization()
    } else{
      identifireViewController = Autorization.beforAutorizationViewController.rawValue
      nameOfStoryBoard = Autorization.beforAutorizationViewController.storyBoardForAutorization()
    }
    
    let navigationController = UIStoryboard(name: nameOfStoryBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: identifireViewController) as? UINavigationController
    
    if let controller = navigationController {
      self.window?.rootViewController = controller
    }
  }
}


