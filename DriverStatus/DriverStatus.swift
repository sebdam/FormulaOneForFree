//
//  DriverStatus.swift
//  DriverStatus
//
//  Created by Sébastien Damiens-Cerf on 31/10/2024.
//

import WidgetKit
import SwiftUI

struct DriverStatus: Widget {
    let kind: String = "DriverStatus"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WidgetTimeLineProvider()) { entry in
            if #available(iOS 17.0, *) {
                driverStatusEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                driverStatusEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Driver status")
        .description("Actual first driver status in championship.")
        .supportedFamilies([
                    .systemSmall,
                    .accessoryRectangular])
    }
}

#Preview(as: .systemSmall) {
    DriverStatus()
} timeline: {
    SimpleEntry(date: .now,
                driverStandings: DriverStanding(position: "2", positionText: "2", points: "42", wins: "12", Driver: JolpyDriver(driverId: "42", url: "", givenName: "Seb Dam", familyName: "Damiens-Cerf", dateOfBirth: "1979-04-25", nationality: "France", permanentNumber: nil, code: "SDC"), Constructors: [Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")]),
                constructorStandings: ConstructorStanding(position: "42", positionText: "42", points: "12", wins: "6", Constructor: Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")),
                driver: Driver(broadcast_name: "SDC", country_code: "SDC", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"),
                driverImage: UIImage(named: "Ferrari"), constructorImage: UIImage(named: "Ferrari"),
                nextRace: "Mexico city championship",
                countDown: "1d:2h:3m")
    SimpleEntry(date: .now,
                driverStandings: DriverStanding(position: "2", positionText: "2", points: "42", wins: "12", Driver: JolpyDriver(driverId: "42", url: "", givenName: "Seb Dam", familyName: "Damiens-Cerf", dateOfBirth: "1979-04-25", nationality: "France", permanentNumber: nil, code: "SDC"), Constructors: [Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")]),
                constructorStandings: ConstructorStanding(position: "42", positionText: "42", points: "12", wins: "6", Constructor: Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")),
                driver: Driver(broadcast_name: "SDC", country_code: "SDC", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"),
                driverImage: UIImage(named: "Ferrari"), constructorImage: UIImage(named: "Ferrari"),
                nextRace: "Mexico city championship",
                countDown: "1d:2h:3m")
}