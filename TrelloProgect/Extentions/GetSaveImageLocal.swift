//
//  GetSaveImageLocal.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/14/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit

//TODO: LocalImagesPovider, split logic of saving to file and requesting image
class GetSaveImageLocal {
  
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
        if saveImage(image: image, fileName: imageName){
          if let image = getSavedImage(named: imageName) {
            completion(image)
          }
        }
        completion(image)
      }
      completion(nil)
    }
  }
  
  func clearTempFolder() {
    let fileManager = FileManager.default
    let tempFolderPath = NSTemporaryDirectory()
    do {
      let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
      for filePath in filePaths {
        try fileManager.removeItem(atPath: tempFolderPath + filePath)
      }
    } catch {
      print("Could not clear temp folder: \(error)")
    }
  }
  
  
  private func saveImage(image: UIImage, fileName : String) -> Bool {
    do {
      let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      let fileURL = documentsURL.appendingPathComponent("\(fileName)")
      if let pngImageData = UIImagePNGRepresentation(image) {
        try pngImageData.write(to: fileURL, options: .atomic)
        return true
      }
    } catch { return false}
    return false
  }
  
  private func getSavedImage(named: String) -> UIImage? {
    if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
      return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
    }
    return nil
  }
}
