//
//  Season.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import Foundation

public struct Season: Codable, Identifiable {
    public let id = UUID()
    let season: String
    let url: String
    
    var seasonAsInt: Int {
        Int(season)!
    }
}

public struct SeasonTable: Codable {
    var Seasons: [Season]
}
