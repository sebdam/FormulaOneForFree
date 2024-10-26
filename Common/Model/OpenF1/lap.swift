//
//  lap.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 20/10/2024.
//
import Foundation

public struct Lap: Codable {
    let date_start : Date?
    
    let driver_number : Int
    
    let duration_sector_1: Double?
    let duration_sector_2: Double?
    let duration_sector_3: Double?
    
    let i1_speed: Double?
    let i2_speed: Double?
    
    let is_pit_out_lap: Bool
    
    let lap_duration: Double?
    let lap_number: Int
    
    let meeting_key : Int
    let session_key : Int
    
    let st_speed : Int?
}

