//
//  BoardTableViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/26/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class BoardTableViewController: UITableViewController {

  var boardViewModel  = BoardTableViewModel()
  private var currentArray :[Any]?
 
  @IBOutlet weak var searchBar: UISearchBar!

  lazy var refreshTableviewControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(BoardTableViewController.handleRefresh(_:)),
                                      for: UIControlEvents.valueChanged)
    refreshControl.tintColor = UIColor.gray
    return refreshControl
  }()
  
  private static let storyboardBefore = "Main"
  private static let beforeViewController = "BeforeNavigationController"
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
      startActivityIndicator()
  }
  
  override func viewWillAppear(_ animated: Bool) {
   // getBoardFromServer()
    boardViewModel.coreDataGetAllBoardWithComplitionBlock { (error) in
      
    }
    searchBar.returnKeyType = .done
    self.tableView.addSubview(refreshTableviewControl)
    navigationItem.title = "BOARDS"
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
      guard let desk = board as? BoardViewModel else {return UITableViewCell()}
      cell.nameOfBoard.text = desk.name
      cell.idOfBoard.text = desk.id
      cell.colorOfBoard.backgroundColor = desk.backgroundColor
      return cell
      }
      return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    tableView.deselectRow(at: indexPath, animated: false)
    guard let tapBoard = boardViewModel.boardsDataSource?.item(at: indexPath) as? BoardViewModel else {return}
    let  listPageViewModel = ListPageViewModel(rootBoard: tapBoard)
    let pageViewController = ListPageViewController(listPageViewModel: listPageViewModel)
    guard let window = UIApplication.shared.windows.first else  {return}
    let navigationController = UINavigationController(rootViewController: pageViewController)
    UIView.transition(with: window, duration: 1, options: .transitionFlipFromLeft, animations: {
      window.rootViewController = navigationController
    }, completion: { completed in })
  }
  
  @IBAction func goToAutorizationScreen(_ sender: UIBarButtonItem) {
    let redistranionController = UIStoryboard.init(name: BoardTableViewController.storyboardBefore, bundle: Bundle.main).instantiateViewController(withIdentifier: BoardTableViewController.beforeViewController) as? UINavigationController
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
    
    DispatchQueue.global(qos: .userInteractive).async {
      self.boardViewModel.getAllBoardWithComplitionBlock { [weak self](result) in
        DispatchQueue.main.async {
          if let error = result{
            let alert = UIAlertController.alertWithError(error)
            self?.present(alert, animated: true)
          } else {
            self?.tableView.reloadData()
            self?.currentArray = self?.boardViewModel.boardsDataSource?.objects
          }
          self?.stopActivityIndicator()
        }
      }
    }
  }
}

extension BoardTableViewController : UISearchBarDelegate{
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard let currentArray = currentArray  as? [BoardViewModel] else {return}
    guard !searchText.isEmpty else {
       boardViewModel.boardsDataSource = ArrayDataSource(with: currentArray)
        tableView.reloadData()
        return
      }
    boardViewModel.boardsDataSource?.objects = currentArray.filter({ (board) -> Bool in
      board.name.lowercased().contains(searchText.lowercased())
    })
    tableView.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
    searchBar.resignFirstResponder()
  }
}
