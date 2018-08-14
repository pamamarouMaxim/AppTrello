//
//  CompareServerRequestWithContext.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 8/12/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

public struct  SequenceDiff<T1, T2>{
  var removed:  [T1]
  var inserted: [T2]
}

public func differenceArrays<T1, T2>(_ contextArray: [T1], _ serverArray: [T2], with compare: (T1,T2) -> Bool) -> SequenceDiff<T1, T2> {
  
  let combinations = contextArray.flatMap { firstElement in (firstElement, serverArray.first { secondElement in compare(firstElement, secondElement) }) }
  let common = combinations.filter { $0.1 != nil }.flatMap { ($0.0, $0.1!) }
  let removed = combinations.filter { $0.1 == nil }.flatMap { ($0.0) }
  let inserted = serverArray.filter { secondElement in !common.contains { compare($0.0, secondElement) } }
  
  return SequenceDiff(removed: removed, inserted: inserted)
}



