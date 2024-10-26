//
//  DriverStanding.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import Foundation
public struct DriverStanding : Codable, Identifiable {
    public let id = UUID()
    
    let position: String?
    let positionText: String
    let points: String
    let wins: String
    let Driver: JolpyDriver
    let Constructors: [Constructor]
}
