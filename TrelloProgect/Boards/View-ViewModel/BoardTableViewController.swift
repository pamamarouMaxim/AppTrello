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
  
  private let identifireOfCell = "BoardTableViewCell"
  private var isSearching = false
  private var filterData  = [String]()
  private var data : [String]?

  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    getBoardFromServer()
    refreshControl.endRefreshing()
  }
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
    guard let cell = tableView.cellForRow(at: indexPath) as? BoardTableViewCell else {return}
    guard let name = cell.nameOfBoard.text, let id = cell.idOfBoard.text, let color = cell.colorOfBoard.backgroundColor else {return}
    let tapBoard = Board(id: id, name: name, backgroundColor: color)
    let  listPageViewModel = ListPageViewModel(rootBoard: tapBoard)
    let pageViewController = ListPageViewController(listPageViewModel: listPageViewModel)
    navigationController?.show(pageViewController, sender: nil)
    tableView.deselectRow(at: indexPath, animated: false)
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    guard let countOfSections = boardViewModel.boardsDataSource?.numberOfSections() else {return 1}
    return countOfSections
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let countOfRows = boardViewModel.boardsDataSource?.numberOfItems(in: section) else {return 1}
    return countOfRows
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: identifireOfCell, for: indexPath) as? BoardTableViewCell {
      let board = boardViewModel.boardsDataSource?.item(at: indexPath)
      guard let desk = board as? Board else {return UITableViewCell()}
      cell.nameOfBoard.text = desk.name
      cell.idOfBoard.text = desk.id
      cell.colorOfBoard.backgroundColor = desk.backgroundColor
      return cell
      }
      return UITableViewCell()
  }
  
  @IBAction func goToAutorizationScreen(_ sender: UIBarButtonItem) {
    
    let redistranionController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BeforeNavigationController") as? UINavigationController
    if let controller = redistranionController{
      guard let window = UIApplication.shared.windows.first else  {return}
      UserSettings.default.token = nil
      UserSettings.default.member = nil
      UIView.transition(with: window, duration: 1, options: .transitionFlipFromLeft, animations: {
        window.rootViewController = controller
      }, completion: { completed in })
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
