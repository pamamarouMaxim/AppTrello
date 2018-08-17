//
//  GetSaveImageLocal.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/14/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit

class LocalImagesProvider {
  
  static let `default` = LocalImagesProvider()
  
  func getImage(FromUrl url : URL, completion :(UIImage?) -> Void) {
    var imageName = String(describing: url)
    imageName = imageName.imageFileName()
    if let image = getSavedImage(named: imageName) {
      completion(image)
    }  else {
      let data = try? Data(contentsOf: url)
      guard let imageData = data else {return}
      let picture = UIImage(data: imageData)
      if let image = picture{
          saveImage(image: image, fileName: imageName)
          completion(image)
      }
      completion(nil)
    }
  }
  
  func removeImage(fileName: String){
    let fileManager = FileManager.default
    guard let documentsUrl =  FileManager.default.urls(for: .documentDirectory,
                                                       in: .userDomainMask).first else {return}
    let documentPath = documentsUrl.path
    do {
        let filePathName = "\(documentPath)/\(fileName)"
        try fileManager.removeItem(atPath: filePathName)
    } catch {
    }
  }
  
  func saveImage(image: UIImage, fileName : String) {
    do {
      let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      let fileURL = documentsURL.appendingPathComponent("\(fileName)")
      if let pngImageData = UIImagePNGRepresentation(image) {
        try pngImageData.write(to: fileURL, options: .atomic)
      }
    } catch {}
  }
  
  
  func getSavedImage(named: String) -> UIImage? {
    if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
      return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
    }
    return nil
  }
}
