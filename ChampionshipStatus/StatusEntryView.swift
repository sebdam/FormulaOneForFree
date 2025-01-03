//
//  StatusEntryView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 25/10/2024.
//
import Foundation
import SwiftUI
import WidgetKit

struct statusEntryView : View {
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
            case .systemMedium: MediumChampionshipStatusEntryView(entry:entry)
            case .systemSmall: SmallChampionshipStatusEntryView(entry:entry)
            case .systemLarge: MediumChampionshipStatusEntryView(entry:entry)
            case .accessoryRectangular: AccessoryRectangularChampionshipStatusEntryView(entry:entry)
            case .accessoryInline: AccessoryInlineChampionshipStatusEntryView(entry:entry)
            default: SmallChampionshipStatusEntryView(entry:entry)
        }
    }
}

struct MediumChampionshipStatusEntryView : View {
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        VStack {
            HStack {
                if(entry.driver != nil && entry.driverStandings != nil){
                    DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true, image:entry.driverImage)
                }
                if(entry.constructorStandings != nil){
                    ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true, image: entry.constructorImage)
                }
                
                if(entry.driverStandings == nil && entry.constructorStandings == nil){
                    Text("No data available")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "arrow.trianglehead.clockwise")
                    .font(.caption2)
                Text(statusEntryView.dateFormatter.string(from: entry.date))
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
    }
}

struct SmallChampionshipStatusEntryView : View {
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        VStack {
            HStack {
                if(entry.driver != nil && entry.driverStandings != nil){
                    DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true)
                }
                if(entry.constructorStandings != nil){
                    ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true)
                }
                
                if(entry.driverStandings == nil && entry.constructorStandings == nil){
                    Text("No data available")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "arrow.trianglehead.clockwise")
                    .font(.caption2)
                Text(statusEntryView.dateFormatter.string(from: entry.date))
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
    }
}


struct AccessoryRectangularChampionshipStatusEntryView : View {
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        HStack {
            if(entry.driver != nil && entry.driverStandings != nil){
                DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true)
            }
            if(entry.constructorStandings != nil){
                ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true)
            }
            
            if(entry.driverStandings == nil && entry.constructorStandings == nil){
                Text("No data available")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct AccessoryInlineChampionshipStatusEntryView : View {
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        HStack {
            let index = entry.nextRace.count > 5 ? entry.nextRace.index(entry.nextRace.startIndex, offsetBy: 5) : entry.nextRace.endIndex
            Text("\(entry.nextRace.prefix(upTo: index))\(entry.nextRace.count > 5 ? "." : ""):\(entry.countDown)")
                .font(.caption2)
        }
    }
}
