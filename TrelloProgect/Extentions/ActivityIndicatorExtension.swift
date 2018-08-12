//
//  ActivityIndicatorExtension.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/9/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  
  private var activityIndicatorTag: Int { return 999999 }
  
  func startActivityIndicator(
    
    style: UIActivityIndicatorViewStyle = .gray,
    location: CGPoint? = nil) {
  
    let loc = location ?? self.view.center
    
      let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: style)
      
      activityIndicator.tag = self.activityIndicatorTag
      
      activityIndicator.center = loc
      activityIndicator.hidesWhenStopped = true
      
      activityIndicator.startAnimating()
      self.view.addSubview(activityIndicator)
    
  }
    
  func stopActivityIndicator() {
      if let activityIndicator = self.view.subviews.filter(
        { $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
      }
  }
}
