//
//  Schedule.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import Foundation

public struct Schedule: Codable {
    let date: String
    let time: String?
    
    var datetime: Date? {
        let formater = DateFormatter()
        formater.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZZZ"
        return formater.date(from: "\(date)T\(time?.replacingOccurrences(of: "Z", with: "+00:00") ?? "00:00:00+00:00")")
    }
}
