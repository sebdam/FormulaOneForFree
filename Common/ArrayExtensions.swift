//
//  ArrayExtensions.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 31/10/2024.
//

extension Array where Element: Hashable {
  func unique() -> [Element] {
    Array(Set(self))
  }
}
