//
//  session.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 20/10/2024.
//
import Foundation

public struct Session: Identifiable, Codable, Equatable {
    public static func == (lhs: Session, rhs: Session) -> Bool {
        lhs.session_key == rhs.session_key && lhs.year == rhs.year && lhs.meeting_key == rhs.meeting_key
    }
    
    private let _id = UUID()
    public var id: UUID { _id }
    
    let circuit_key : Int
    let circuit_short_name : String
    let country_code : String
    let country_key : Int
    let country_name : String
    
    let date_start : Date
    
    let gmt_offset : String
    let location : String
    let meeting_key : Int
    let session_key : Int
    let session_name : String
    let session_type : String
    let year : Int
    
    var positions:[Position]?
}
