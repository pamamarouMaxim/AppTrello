//
//  BoardTableViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/26/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class BoardTableViewController: UITableViewController {
  
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
    let addNewBoard = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAddNewBoard(_:)))
    navigationItem.setRightBarButton(addNewBoard, animated: false)
    navigationItem.title = "BOARDS"
    getBoardFromServer()
  }

  @objc func tappedAddNewBoard(_ sender: UIBarButtonItem) {
    let addBoardViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddBoardViewController") as? AddBoardViewController
    if let boardController = addBoardViewController {
      self.navigationController?.show(boardController, sender: nil)
    }
  }
  
  func getBoardFromServer() {
    ViewModel().getAllBoardWithComplitionBlock { [weak self](result) in
      if let array = result as? [Board] {
        self?.arrayOfBoard = array
         self?.tableView.reloadData()
      }
    }
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}
