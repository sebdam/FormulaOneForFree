//
//  JolpyDriver.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import Foundation

public struct JolpyDriver: Codable {
    let driverId: String
    let url: String
    let givenName: String
    let familyName: String
    let dateOfBirth: String
    let nationality: String
    let permanentNumber: String?
    let code: String?
}
