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
  var images = [UIImage(named: "clock"),UIImage(named: "clock"),UIImage(named: "clock")]
  var collectionView: UICollectionView!
  
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.selectionStyle = .none
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    
    let poin = contentView.frame.origin
   
    collectionView = UICollectionView(frame:   CGRect(x: poin.x, y: poin.y, width: contentView.bounds.width, height: UIScreen.main.bounds.width/2)
    , collectionViewLayout: layout)
    collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
   
    contentView.addSubview(collectionView)
    addConstraintsToCollectionView()
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

  override func awakeFromNib() {
      super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
  }
  
  private func addConstraintsToCollectionView(){
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    let pointX = NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
    let pointY = NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0)
    let height = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
    let width = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
    contentView.addConstraints([height,width,pointY,pointX])
  }
  
  
//  override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//    collectionView.frame =  CGRect(x: 0, y: 0, width: targetSize.width, height: CGFloat(MAXFLOAT))
//     collectionView.layoutIfNeeded()
//     return collectionView.collectionViewLayout.collectionViewContentSize
//  }
}

extension CollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let attachmentsCount = viewModel?.attachments?.count else {return 0}
    return attachmentsCount
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    guard let attachments = viewModel?.attachments else {return UICollectionViewCell()}
    if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as? CollectionViewCell {
      itemCell.backgroundColor = UIColor.lightGray
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
//   let point = frame.origin
//   let width = frame.width
//    guard let superViewHeight = superview?.bounds.height else {return}
//    frame = CGRect(x: point.x, y: point.y, width: width, height: superViewHeight/3)
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


