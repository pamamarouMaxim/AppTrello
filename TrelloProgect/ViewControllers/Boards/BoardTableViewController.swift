//
//  BoardTableViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/26/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit
import CoreData

class BoardTableViewController: UITableViewController,NSFetchedResultsControllerDelegate{

  var boardViewModel  = BoardTableViewModel()
  private var currentArray :[Any]?
  private var secondTimeWillAppear = false
 
  @IBOutlet weak var searchBar: UISearchBar!
  
  let coreDataManager = CoreDataManager()
  lazy var persistentContainer = coreDataManager.persistentContainer
  
  fileprivate lazy var fetchedResultsController: NSFetchedResultsController<BoardEntity> = {
    let fetchRequest: NSFetchRequest<BoardEntity> = BoardEntity.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    return fetchedResultsController
  }()
  
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
    getBoardFromServer()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    searchBar.returnKeyType = .done
    self.tableView.addSubview(refreshTableviewControl)
    navigationItem.title = "BOARDS"
    if secondTimeWillAppear{
       executeFetchRequest()
    }
    secondTimeWillAppear = true
    stopActivityIndicator()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard  let count = fetchedResultsController.fetchedObjects?.count else {return 0}
    return count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: identifireOfCell, for: indexPath) as? BoardTableViewCell {
      guard let board = fetchedResultsController.object(at: indexPath) as? BoardEntity else {return UITableViewCell()}
      cell.nameOfBoard.text = board.name
      cell.idOfBoard.text = board.id
      if let color = board.backgroundColor{
        cell.colorOfBoard.backgroundColor = UIColor.colorWithHexString(hex: color)
      }
      return cell
    }
      return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    
    guard let boardEntity = fetchedResultsController.object(at: indexPath) as? BoardEntity else {return}
    guard let id = boardEntity.id, let name = boardEntity.name, let color = boardEntity.backgroundColor else {return}
    let board = Board(id: id, name: name, backgroundColor: color)
    let boardViewModel = BoardViewModel(board)
    tableView.deselectRow(at: indexPath, animated: false)
    let  listPageViewModel = ListPageViewModel(rootBoard: boardViewModel)
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
            self?.executeFetchRequest()
          } else {
            self?.executeFetchRequest()
           // self?.currentArray = self?.boardViewModel.boardsDataSource?.objects
          }
          self?.stopActivityIndicator()
        }
      }
    }
  }
  
  private func executeFetchRequest(){
    do {
      try fetchedResultsController.performFetch()
    } catch (let error){
      let alert = UIAlertController.alertWithError(error)
      self.present(alert, animated: true)
    }
    tableView.reloadData()
  }
}

extension BoardTableViewController : UISearchBarDelegate{
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard let currentArray = currentArray  as? [BoardViewModel] else {return}
    guard !searchText.isEmpty else {
     //  boardViewModel.boardsDataSource = ArrayDataSource(with: currentArray)
        tableView.reloadData()
        return
      }
   // boardViewModel.boardsDataSource?.objects = currentArray.filter({ (board) -> Bool in
    //  board.name.lowercased().contains(searchText.lowercased())
  //  })
    tableView.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
    searchBar.resignFirstResponder()
  }
}
