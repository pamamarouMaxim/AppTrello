//
//  CollectionTableViewCell.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/8/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell,BindableCell {
  
  var viewModel: BindableCellViewModel?
  let collectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0,
                                                        width: UIScreen.main.bounds.width,
                                                        height: UIScreen.main.bounds.width/2),
                                          collectionViewLayout: layout)
    return collectionView
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
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
    self.viewModel = viewModel
  }

}

extension CollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let attachmentsCount =  viewModel?.cardInfo?.attachments?.count else {return 0}
    return attachmentsCount
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    guard let attachments = viewModel?.cardInfo?.attachments else {return UICollectionViewCell()}
    if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as? CollectionViewCell {
      itemCell.backgroundColor = UIColor.lightGray
      //TODO: incapsulate queuqes switching into getImage
      DispatchQueue.global().async {
        self.viewModel?.getImage(FromUrlSring: attachments[indexPath.row], complition: { (image) in
          DispatchQueue.main.async {
            guard let image = image else {return}
                 itemCell.imageView.image = image
          }
        })
      }
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
    guard let navigationController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController else {return}
    controller.image = cell.imageView.image
    navigationController.pushViewController(controller, animated: true)
  }
}

extension CollectionTableViewCell: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let wight = UIScreen.main.bounds.width
    return CGSize(width: wight/3,
                      height:  wight/3)
  }
}


