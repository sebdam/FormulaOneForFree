//
//  JolpyDriver.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import Foundation

public struct DriverTable: Codable {
    let season: String
    var Drivers: [JolpyDriver]
}

public struct JolpyDriver: Codable, Identifiable, Hashable {
    private let _id = UUID()
    public var id: UUID { _id }
    
    let driverId: String
    let url: String
    let givenName: String
    let familyName: String
    let dateOfBirth: String
    let nationality: String
    let permanentNumber: String?
    let code: String?
}
