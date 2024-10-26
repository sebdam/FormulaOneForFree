//
//  DriverStanding.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import Foundation
public struct DriverStanding : Codable, Identifiable {
    private let _id = UUID()
    public var id: UUID { _id }
    
    let position: String?
    let positionText: String
    let points: String
    let wins: String
    let Driver: JolpyDriver
    let Constructors: [Constructor]
}
