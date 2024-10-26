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
    private let _id = UUID()
    public var id: UUID { _id }
    let constructorId: String
    let url: String
    let name: String
    let nationality: String
}
