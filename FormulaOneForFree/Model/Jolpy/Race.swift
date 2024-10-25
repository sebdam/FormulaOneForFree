//
//  race.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 19/10/2024.
//

import Foundation

public struct RaceTable: Codable {
    let season: String
    var Races: [Race]
}

public struct Race: Codable, Identifiable, Equatable {
    public let id = UUID()
        public static func == (lhs: Race, rhs: Race) -> Bool {
        lhs.raceName == rhs.raceName && lhs.season == rhs.season
    }
    
    let season: String
    let round: String
    let url: String
    let raceName: String
    let Circuit: Circuit
    let date: String
    let time: String?
    
    var datetime: Date? {
        let formater = DateFormatter()
        formater.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZZZ"
        return formater.date(from: "\(date)T\(time?.replacingOccurrences(of: "Z", with: "+00:00") ?? "00:00:00+00:00")")
    }
    
    let FirstPractice: Schedule?
    let SecondPractice: Schedule?
    let ThirdPractice: Schedule?
    let SprintQualifying: Schedule?
    let Sprint: Schedule?
    let Qualifying: Schedule?
    
    var Results: [Result]? = []
}
