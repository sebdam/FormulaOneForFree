//
//  ConstructorStanding.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import Foundation
public struct ConstructorStanding : Codable, Identifiable {
    public var id: UUID { UUID() }
    
    let position: String?
    let positionText: String
    let points: String
    let wins: String
    let Constructor: Constructor
}
