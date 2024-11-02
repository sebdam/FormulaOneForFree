//
//  DriverStatusEntryView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 31/10/2024.
//
import Foundation
import SwiftUI
import WidgetKit

struct driverStatusEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: WidgetTimeLineProvider.Entry
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM hh:mm"
        return formatter
    }()

    @ViewBuilder
    var body: some View {
        switch family {
            case .systemMedium: MediumDriverStatusEntryView(entry:entry)
            case .systemSmall: SmallDriverStatusEntryView(entry:entry)
            case .systemLarge: MediumDriverStatusEntryView(entry:entry)
            case .accessoryRectangular: AccessoryRectangularDriverStatusEntryView(entry:entry)
            default: SmallDriverStatusEntryView(entry:entry)
        }
    }
}

struct MediumDriverStatusEntryView : View {
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        VStack {
            HStack {
                if(entry.driver != nil && entry.driverStandings != nil){
                    DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true, image:entry.driverImage)
                }
                
                if(entry.driverStandings == nil){
                    Text("No data available")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "arrow.trianglehead.clockwise")
                    .font(.caption2)
                Text(driverStatusEntryView.dateFormatter.string(from: entry.date))
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
    }
}

struct SmallDriverStatusEntryView : View {
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        VStack {
            HStack {
                if(entry.driver != nil && entry.driverStandings != nil){
                    DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true, image:entry.driverImage, condensed: true)
                }
                if(entry.driverStandings == nil){
                    Text("No data available")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "arrow.trianglehead.clockwise")
                    .font(.caption2)
                Text(driverStatusEntryView.dateFormatter.string(from: entry.date))
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
    }
}


struct AccessoryRectangularDriverStatusEntryView : View {
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        HStack {
            if(entry.driver != nil && entry.driverStandings != nil){
                DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true, image:entry.driverImage, condensed: true)
            }
            if(entry.driverStandings == nil){
                Text("No data available")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
