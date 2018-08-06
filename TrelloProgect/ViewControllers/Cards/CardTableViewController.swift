//
//  CardTableViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/5/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class CardTableViewController: UITableViewController {

  var cardViewModel : CardViewModel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      cardViewModel.data()
      cardViewModel.getCardInfo { (result) in
        
      }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
      return (cardViewModel.dataSourse?.numberOfSections())!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (cardViewModel.dataSourse?.numberOfItems(in: section))!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

      let cell = cardViewModel.dataSourse?.item(at: indexPath)
  
      if  let col = cell as? CollectionViewTableViewCell{
        return col
      } else if let image = cell as? CardTableViewCell{
        return image
      } else if let   card  = cell as? UITableViewCell{
        
        return card
      }
      
        return UITableViewCell()
    }
  
  
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
    if let cell = tableView.cellForRow(at: indexPath){
      if let c = cell as? CollectionViewTableViewCell{
        return tableView.bounds.height/4
      }
    }
    return 44
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    let cell = tableView.cellForRow(at: indexPath)
    if cell?.reuseIdentifier == "DescriptionCell"{
      let conrtoller = UIStoryboard(name: "List", bundle: Bundle.main ).instantiateViewController(withIdentifier: "CardDescriptionViewController") as? CardDescriptionViewController
      guard let cardDescriptionViewController = conrtoller else {return}
      cardDescriptionViewController.cardDiscriptionViewModel = CardDiscriptionViewModel(api: ServerManager.default, card: cardViewModel.card)
      navigationController?.pushViewController(cardDescriptionViewController, animated: true)
    }
  }
}


