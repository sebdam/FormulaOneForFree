//
//  Standings.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import Foundation

public struct StandingsTable : Codable {
    let season: String
    let round: String
    let StandingsLists: [StandingsList]
}

public struct StandingsList : Codable {
    let season: String
    let round: String
    let DriverStandings: [DriverStanding]?
    let ConstructorStandings: [ConstructorStanding]?
}
