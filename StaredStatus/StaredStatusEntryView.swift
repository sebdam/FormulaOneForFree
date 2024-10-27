//
//  StaredStatusEntryView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 26/10/2024.
//
import Foundation
import SwiftUI
import WidgetKit

struct staredStatusEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: StaredProvider.Entry

    @ViewBuilder
    var body: some View {
        switch family {
            case .systemMedium: MediumStaredStatusEntryView(entry:entry)
            case .systemSmall: SmallStaredStatusEntryView(entry:entry)
            case .systemLarge: MediumStaredStatusEntryView(entry:entry)
            case .accessoryRectangular: AccessoryRectangularStaredStatusEntryView(entry:entry)
            default: SmallStaredStatusEntryView(entry:entry)
        }
    }
}

struct MediumStaredStatusEntryView : View {
    var entry: StaredProvider.Entry
    
    var body: some View {
        VStack {
            if(entry.driver != nil && entry.driverStandings != nil){
                Spacer()
                HStack {
                    Text("#\(entry.driverStandings!.positionText)")
                    DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true, image:entry.driverImage)
                        .frame(maxWidth: .infinity)
                }
            }
            if(entry.constructorStandings != nil){
                Spacer()
                HStack {
                    Text("#\(entry.constructorStandings!.positionText)")
                    ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true, image: entry.constructorImage)
                        .frame(maxWidth: .infinity)
                }
                
            }
            
            if(entry.driverStandings == nil && entry.constructorStandings == nil){
                Spacer()
                Text("No data available")
            }
            
            Spacer()
            
            HStack {
                Image(systemName: "star")
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

struct SmallStaredStatusEntryView : View {
    var entry: StaredProvider.Entry
    
    var body: some View {
        VStack(spacing: 5) {
            if(entry.driver != nil && entry.driverStandings != nil){
                Spacer()
                HStack {
                    Text("#\(entry.driverStandings!.positionText)")
                    DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true)
                        .frame(maxWidth: .infinity)
                }
            }
            if(entry.constructorStandings != nil){
                Spacer()
                HStack {
                    Text("#\(entry.constructorStandings!.positionText)")
                    ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true)
                        .frame(maxWidth: .infinity)
                }
            }
            
            if(entry.driverStandings == nil && entry.constructorStandings == nil){
                Spacer()
                Text("No data available")
                    .frame(maxWidth: .infinity)
            }
            
            Spacer()
            
            HStack {
                Image(systemName: "star")
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


struct AccessoryRectangularStaredStatusEntryView : View {
    var entry: StaredProvider.Entry
    
    var body: some View {
        VStack {
            if(entry.driver != nil && entry.driverStandings != nil){
                HStack{
                    Image(systemName: "star")
                    Text("\(entry.driverStandings!.positionText)")
                    Spacer()
                    DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true)
                        .frame(maxWidth: .infinity)
                }
                
            }
            if(entry.constructorStandings != nil){
                HStack{
                    Image(systemName: "star")
                    Text("\(entry.driverStandings!.positionText)")
                    Spacer()
                    ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true)
                        .frame(maxWidth: .infinity)
                }
            }
            if(entry.driverStandings == nil && entry.constructorStandings == nil){
                HStack{
                    Image(systemName: "star")
                    Spacer()
                    Text("No data available")
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
