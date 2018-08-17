//
//  CollectionTableViewCell.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/8/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell,BindableCell {
  
  static let CellHight = UIScreen.main.bounds.width/2.5
  
  var collectionModel : CollectionTableViewCellViewModel?
  weak var delegate: CardInfoTableViewController?
  let collectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let screenWidth = UIScreen.main.bounds.width
    var collectionView = UICollectionView(frame: CGRect(x: 0, y: 0,
                                                        width: screenWidth,
                                                        height: CellHight),
                                          collectionViewLayout: layout)
    return collectionView
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    
    collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    
    contentView.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
  }

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var reuseIdentifier: String{
    return "CollectionTableViewCell"
  }
 
  
  func setup(with viewModel: BindableCellViewModel) {
    guard let collectionViewModel = viewModel as? CollectionTableViewCellViewModel else {return}
    self.collectionModel = collectionViewModel
  }
}


extension CollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

  override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                        verticalFittingPriority: UILayoutPriority) -> CGSize{
    collectionView.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: CollectionTableViewCell.CellHight)
    let size = collectionView.collectionViewLayout.collectionViewContentSize
    let newSize = CGSize(width: size.width, height: size.height)
    return newSize
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let attachmentsCount =  collectionModel?.cardInfo?.attachments?.count else {return 0}
    return attachmentsCount
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    guard let attachments = collectionModel?.cardInfo?.attachments else {return UICollectionViewCell()}
    if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as? CollectionViewCell {
      itemCell.backgroundColor = UIColor.lightGray
        self.collectionModel?.getImage(FromUrlSring: attachments[indexPath.row], complition: { (image) in
            guard let image = image else {return}
                 itemCell.imageView.image = image
                 itemCell.path = attachments[indexPath.row]
        })
      
      return itemCell
    }
    return UICollectionViewCell()
  }
  
  override func layoutSubviews() {    
    super.layoutSubviews()
   let point = frame.origin
   let width = frame.width
    guard let superViewHeight = superview?.bounds.height else {return}
    frame = CGRect(x: point.x, y: point.y, width: width, height: superViewHeight/3)
  }
  
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else {return}
    guard let controller = UIStoryboard(name: "List", bundle: nil).instantiateViewController(withIdentifier: "CardImageViewController") as? CardImageViewController else {return}
    guard let delegate = delegate else {return}
    controller.pathToImage = cell.path
    delegate.navigationController?.pushViewController(controller, animated: true)
  }
}

extension CollectionTableViewCell: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: CollectionTableViewCell.CellHight,
                  height:  CollectionTableViewCell.CellHight)
  }
}


