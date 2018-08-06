//
//  CollectionViewTableViewCell.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/6/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

  @IBOutlet weak var collectionView: UICollectionView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewID")
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension CollectionViewTableViewCell : UICollectionViewDelegate{
  
}

extension CollectionViewTableViewCell : UICollectionViewDataSource{
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    
    return 2
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewID", for: indexPath as IndexPath) as! CollectionViewCell
    
    let added = UIImageView(image: UIImage(named: "clock.png"))
    cell.addSubview(added)
    
    return cell
  }
  
}
