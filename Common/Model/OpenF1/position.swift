//
//  position.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 20/10/2024.
//
import Foundation

public struct Position: Identifiable, Equatable, Codable {
    private let _id = UUID()
    public var id: UUID { _id }
    
    public static func == (lhs: Position, rhs: Position) -> Bool {
        lhs.id == rhs.id
    }
    
    let date : Date
    
    let driver_number : Int
    let meeting_key : Int
    let session_key : Int
    let position : Int
    
    var laps: [Lap]?
    
    var best_lap: Lap? {
        laps?
            .filter({ $0.is_pit_out_lap == false })
            .sorted(by: {$0.lap_duration ?? Double.infinity < $1.lap_duration ?? Double.infinity})
            .first
    }
    
    var duration: Double? {
        laps?.reduce(into: 0) { $0 += $1.lap_duration ?? 0 }
    }
}
