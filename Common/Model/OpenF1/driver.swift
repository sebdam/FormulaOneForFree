//
//  driver.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 20/10/2024.
//
import Foundation

public struct Driver: Codable, Identifiable, Hashable {
    private let _id = UUID()
    public var id: UUID { _id }
    
    let broadcast_name:String
    let country_code: String?
    let driver_number: Int
    let first_name: String?
    let full_name : String
    let headshot_url: String?
    let last_name: String?
    let meeting_key: Int
    let name_acronym: String
    let session_key: Int
    let team_colour: String?
    let team_name: String?
}
