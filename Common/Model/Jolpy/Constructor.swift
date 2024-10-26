//
//  Constructor.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//
import Foundation

public struct ConstructorTable: Codable {
    var Constructors: [Constructor]
}

public struct Constructor: Codable, Identifiable, Hashable {
    public var id: UUID { UUID() }
    let constructorId: String
    let url: String
    let name: String
    let nationality: String
}
