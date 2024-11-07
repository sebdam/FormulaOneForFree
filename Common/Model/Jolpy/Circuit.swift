//
//  Circuit.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import Foundation

public struct CircuitTable: Codable {
    var Circuits: [Circuit]
}

public struct Circuit: Codable {
    let circuitId: String
    let url: String
    let circuitName: String
    let Location: Location
}
