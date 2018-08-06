//
//  ColorTableViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/27/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class ColorTableViewController: UITableViewController {
  
  private var arrayOfColor : [MyColor]?
  private var selectedCell : UITableViewCell?

  override func viewDidLoad() {
      super.viewDidLoad()
    var color = [MyColor]()
    color = [.blue,.gray,.green,.lime,.orange,.pink,.purple,.red,.sky]
    arrayOfColor = color
  }

  override func willMove(toParentViewController parent: UIViewController?){
    super.willMove(toParentViewController: parent)
    
    guard let cell = selectedCell else {return}
    guard let number = navigationController?.viewControllers.count  else {return}
    if number >= 2{
      guard  let controller = navigationController?.viewControllers[number - 2] as? AddBoardViewController else {return}
      controller.selectedCellInColor = cell
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
   return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   if let colors = arrayOfColor  { return colors.count} else {return 0}
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    if let array = arrayOfColor{
      let color = array[indexPath.row]
      cell.contentView.backgroundColor = color.value
      cell.textLabel?.backgroundColor  = color.value
      cell.textLabel?.text  = color.rawValue
    }
   return cell
  }
  
  override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    selectedCell?.accessoryType = .none
    let cell = self.tableView.cellForRow(at: indexPath)
    selectedCell = cell
    cell?.accessoryType = .checkmark
 }
}

extension ColorTableViewController{
  // TODO: move to settings
  enum MyColor : String{
    case red     = "red"
    case blue    = "blue"
    case orange  = "orange"
    case green   = "green"
    case purple = "purple"
    case pink    = "pink"
    case lime    = "lime"
    case sky     = "sky"
    case gray    = "gray"
    
    var value: UIColor {
      get {
        switch self {
        case .red:
          return UIColor.red
        case .blue:
          return UIColor.blue
        case .orange:
          return UIColor.orange
        case .green:
          return UIColor.green
        case .purple:
          return UIColor.purple
        case .gray:
          return UIColor.gray
        case .lime:
          return UIColor(red: 174/255, green: 255/255, blue: 204/255, alpha: 1)
        case .pink:
          return UIColor(red: 233/255, green: 92/255, blue: 235/255, alpha: 1)
        case .sky:
          return UIColor(red: 75/255, green: 255/255, blue: 235/255, alpha: 1)
        }
      }
    }
  }
}
