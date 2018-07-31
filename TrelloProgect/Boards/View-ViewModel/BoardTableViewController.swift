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
 
  @IBOutlet weak var searchBar: UISearchBar!

  lazy var refreshTableviewControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(BoardTableViewController.handleRefresh(_:)),
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
  private var isSearching = false
  private var filterData  = [String]()
  private var data : [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  override func viewWillAppear(_ animated: Bool) {
    searchBar.returnKeyType = .done
    self.tableView.addSubview(refreshTableviewControl)
    navigationItem.title = "BOARDS"
    getBoardFromServer()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
     tableView.deselectRow(at: indexPath, animated: false)
    guard let cell = tableView.cellForRow(at: indexPath) as? BoardTableViewCell else {return}
//     guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: "ListPageViewController") as? ListPageViewController  else {return}
  
    let pageViewController = ListPageViewController.init(idOfboard: cell.idOfBoard.text!, colorOfBoard:  cell.colorOfBoard.backgroundColor!)
//    pageViewController.idOfboard = cell.idOfBoard.text
//    pageViewController.colorOfBoard = cell.colorOfBoard.backgroundColor
    navigationController?.show(pageViewController, sender: true)
 
  }
  
    override func numberOfSections(in tableView: UITableView) -> Int {
      guard let countOfSections = boardViewModel.boards?.numberOfSections() else {return 1}
      return countOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let countOfRows = boardViewModel.boards?.numberOfItems(in: section) else {return 1}
      return countOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if let cell = tableView.dequeueReusableCell(withIdentifier: identifireOfCell, for: indexPath) as? BoardTableViewCell {
        let board = boardViewModel.boards?.item(at: indexPath)
        ///
        guard let desk = board as? Board else {return UITableViewCell()}
        cell.nameOfBoard.text = desk.name
        cell.idOfBoard.text = desk.id
        cell.colorOfBoard.backgroundColor = UIColor.colorWithHexString(hex: desk.prefs.backgroundColor)
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
  
  private func getBoardFromServer() {
    boardViewModel.getAllBoardWithComplitionBlock { [weak self](result) in
       self?.tableView.reloadData()
    }
  }
}

extension BoardTableViewController : UISearchBarDelegate{
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text == nil || searchBar.text == ""{
      isSearching = false
      view.endEditing(true)
      tableView.reloadData()
    } else {
      isSearching = true
      guard let value  = data else {return}
      filterData = value.filter( {$0 == searchBar.text})
      tableView.reloadData()
    }
  }
}

extension UIColor{
  static func colorWithHexString (hex:String) -> UIColor {
    
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
