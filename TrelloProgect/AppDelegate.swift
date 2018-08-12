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
   
    CoreDataManager.default.saveContext()
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


