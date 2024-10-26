//
//  Result.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import Foundation

public struct Result: Codable {
    let number: String
    let position: String
    let positionText: String
    let points: String
    let Driver: JolpyDriver
    let Constructor: Constructor
    let grid: String
    let laps: String
    let status: String
}
