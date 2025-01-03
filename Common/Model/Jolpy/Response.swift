//
//  Response.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import Foundation

public struct JolpiRacesData: Codable {
    var MRData: MRData
}

public struct MRData: Codable {
    var limit:String?
    var offset:String?
    var total:String?
    var ConstructorTable: ConstructorTable?
    var CircuitTable: CircuitTable?
    var SeasonTable: SeasonTable?
    var RaceTable: RaceTable?
    var DriverTable: DriverTable?
    var StandingsTable: StandingsTable?
}
