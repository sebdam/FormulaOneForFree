//
//  race.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 19/10/2024.
//

import Foundation

public struct JolpiRacesData: Codable {
    var MRData: MRData
}

public struct MRData: Codable {
    var limit:String?
    var offset:String?
    var total:String?
    var SeasonTable: SeasonTable?
    var RaceTable: RaceTable?
}

public struct SeasonTable: Codable {
    var Seasons: [Season]
}

public struct RaceTable: Codable {
    let season: String
    var Races: [Race]
}

public struct Season: Codable {
    let season: String
    let url: String
}

public struct Race: Codable, Equatable {
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

public struct Schedule: Codable {
    let date: String
    let time: String?
    
    var datetime: Date? {
        let formater = DateFormatter()
        formater.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZZZ"
        return formater.date(from: "\(date)T\(time?.replacingOccurrences(of: "Z", with: "+00:00") ?? "00:00:00+00:00")")
    }
}

public struct Circuit: Codable {
    let circuitId: String
    let url: String
    let circuitName: String
    let Location: Location
}

public struct Location: Codable {
    let lat: String
    let long: String
    let locality: String
    let country: String
}

public struct Result: Codable {
    let number: String
    let position: String
    let positionText: String
    let points: String
    let Driver: JolpyDriver
    let Constructor: Constructor
    let grid: String
    let laps: String
    let status: String
}

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

public struct Constructor: Codable {
    let constructorId: String
    let url: String
    let name: String
    let nationality: String
}
