//
//  location.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 02/11/2024.
//
import Foundation

public struct DriverLocation: Identifiable, Codable, Equatable {
    
    private let _id = UUID()
    public var id: UUID { _id }
    
    public static func == (lhs: DriverLocation, rhs: DriverLocation) -> Bool {
        lhs.id == rhs.id
    }
    
    let date : Date?
    
    let driver_number : Int
    
    let meeting_key : Int
    let session_key : Int
    
    let x: Int
    let y: Int
    let z: Int
    
    var driver: Driver? = nil
}

