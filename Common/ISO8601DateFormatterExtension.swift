//
//  ISO8601DateFormatterExtension.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 29/11/2024.
//
import Foundation

extension ISO8601DateFormatter {
  func microsecondsDate(from dateString: String) -> Date? {
    guard let millisecondsDate = date(from: dateString) else { return nil }
    guard let fractionIndex = dateString.lastIndex(of: ".") else { return millisecondsDate }
    guard let tzIndex = dateString.lastIndex(of: "Z") else { return millisecondsDate }
    guard let startIndex = dateString.index(fractionIndex, offsetBy: 4, limitedBy: tzIndex) else { return millisecondsDate }
    // Pad the missing zeros at the end and cut off nanoseconds
    let microsecondsString = dateString[startIndex..<tzIndex].padding(toLength: 3, withPad: "0", startingAt: 0)
    guard let microseconds = TimeInterval(microsecondsString) else { return millisecondsDate }
    return Date(timeIntervalSince1970: millisecondsDate.timeIntervalSince1970 + microseconds / 1_000_000.0)
  }
}
