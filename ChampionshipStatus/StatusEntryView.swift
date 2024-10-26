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
    var entry: Provider.Entry

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
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            if(entry.driver != nil && entry.driverStandings != nil){
                Spacer()
                DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true, image:entry.driverImage)
            }
            if(entry.constructorStandings != nil){
                Spacer()
                ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true, image: entry.constructorImage)
            }
            
            if(entry.driverStandings == nil && entry.constructorStandings == nil){
                Spacer()
                Text("No data available")
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "arrow.trianglehead.clockwise")
                    .font(.caption2)
                Text(entry.date, style: .date)
                    .font(.caption)
                Text(entry.date, style: .time)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
    }
}

struct SmallChampionshipStatusEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(spacing: 5) {
            if(entry.driver != nil && entry.driverStandings != nil){
                Spacer()
                DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true)
            }
            if(entry.constructorStandings != nil){
                Spacer()
                ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true)
            }
            
            if(entry.driverStandings == nil && entry.constructorStandings == nil){
                Spacer()
                Text("No data available")
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "arrow.trianglehead.clockwise")
                    .font(.caption2)
                Text(entry.date, style: .time)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
    }
}


struct AccessoryRectangularChampionshipStatusEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
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
    }
}


struct AccessoryInlineChampionshipStatusEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        HStack {
            let index = entry.nextRace.index(entry.nextRace.startIndex, offsetBy: 5)
            Text("\(entry.nextRace.prefix(upTo: index)).:\(entry.countDown)")
                .font(.caption2)
        }
    }
}
