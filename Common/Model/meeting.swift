//
//  meeting.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 19/10/2024.
//
import Foundation

public struct Meeting: Codable {
    let circuit_key : Int
    let circuit_short_name : String
    let country_code : String
    let country_key : Int
    let country_name : String
    
    let date_start : Date
    
    let gmt_offset : String
    let location : String
    let meeting_key : Int
    let meeting_name : String
    let meeting_official_name : String
    let year : Int
    
    var sessions: [Session]?
}
