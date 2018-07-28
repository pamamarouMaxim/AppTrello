//
//  BoardTableViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/26/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class BoardTableViewController: UITableViewController {


  var boardViewModel  = BoardViewModel()
  
  lazy var refreshTableviewControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action:
      #selector(BoardTableViewController.handleRefresh(_:)),
                             for: UIControlEvents.valueChanged)
    refreshControl.tintColor = UIColor.gray
    
    return refreshControl
  }()
  
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    
    getBoardFromServer()
    refreshControl.endRefreshing()
  }
  
  private var arrayOfBoard: [Board]? //TODO: move to viewModel
  private let identifireOfCell = "BoardTableViewCell"
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
  
  override func viewWillAppear(_ animated: Bool) {
    self.tableView.addSubview(refreshTableviewControl)
    navigationItem.title = "BOARDS"
    getBoardFromServer()
  }


  func getBoardFromServer() {
    boardViewModel.getAllBoardWithComplitionBlock { [weak self](result) in
      if let array = result as? [Board] {
        self?.arrayOfBoard = array
         self?.tableView.reloadData()
      }
    }
  }
  
  // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      if let array = arrayOfBoard {return array.count} else {return 0}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if let cell = tableView.dequeueReusableCell(withIdentifier: identifireOfCell, for: indexPath) as? BoardTableViewCell {
        if let array = arrayOfBoard {
          let board = array[indexPath.row]
          cell.nameOfBoard.text = board.name
          //cell.colorOfBoard.backgroundColor = colorWithHexString(hex: board.hexColor)
        }
        return cell
      }
        return UITableViewCell()
    }
  
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
  
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      
        if editingStyle == .delete {
          if let array = arrayOfBoard {
            var boards = array
            let board = boards[indexPath.row]
            boards.remove(at: indexPath.row)
            arrayOfBoard = boards
            tableView.deleteRows(at: [indexPath], with: .fade)
            ServerManager.default.removeBoardWithId(board.id, completion: { (_) in })
          }
        } else if editingStyle == .insert {
       }
    }
  @IBAction func goToAutorizationScreen(_ sender: UIBarButtonItem) {
    
    let redistranionController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BeforeNavigationController") as? UINavigationController
    
    if let controller = redistranionController{
      guard let window = UIApplication.shared.windows.first else  {return}
      UserSettings.default.token = nil
      UserSettings.default.member = nil
      UIView.transition(with: window, duration: 1, options: .transitionFlipFromLeft, animations: {
        window.rootViewController = controller
      }, completion: { completed in
        
      })
    }
  }
}

extension BoardTableViewController{
  func colorWithHexString (hex:String) -> UIColor {
    
    var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
      cString = (cString as NSString).substring(from: 1)
    }
    
    if (cString.count != 6) {
      return UIColor.gray
    }
    
    let rString = (cString as NSString).substring(to: 2)
    let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
    let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
  }
}
