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
    var entry: WidgetTimeLineProvider.Entry
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM hh:mm"
        return formatter
    }()

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
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        VStack {
            HStack {
                if(entry.driver != nil && entry.driverStandings != nil){
                    VStack {
                        Text("\(entry.driverStandings!.positionText)")
                        DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true, image:entry.driverImage)
                    }
                }
                if(entry.constructorStandings != nil){
                    VStack {
                        Text("\(entry.constructorStandings!.positionText)")
                        ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true, image: entry.constructorImage)
                    }
                }
                
                if(entry.driverStandings == nil && entry.constructorStandings == nil){
                    Text("No data available")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            
            HStack {
                Image(systemName: "star")
                Spacer()
                Image(systemName: "arrow.trianglehead.clockwise")
                    .font(.caption2)
                Text(staredStatusEntryView.dateFormatter.string(from: entry.date))
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
    }
}

struct SmallStaredStatusEntryView : View {
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        VStack {
            HStack {
                if(entry.driver != nil && entry.driverStandings != nil){
                    VStack {
                        Text("\(entry.driverStandings!.positionText)")
                        DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true)
                    }
                }
                if(entry.constructorStandings != nil){
                    VStack {
                        Text("\(entry.constructorStandings!.positionText)")
                        ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true)
                    }
                }
                
                if(entry.driverStandings == nil && entry.constructorStandings == nil){
                    Text("No data available")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            
            HStack {
                Image(systemName: "star")
                Spacer()
                Image(systemName: "arrow.trianglehead.clockwise")
                    .font(.caption2)
                Text(staredStatusEntryView.dateFormatter.string(from: entry.date))
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
    }
}


struct AccessoryRectangularStaredStatusEntryView : View {
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        HStack {
            if(entry.driver != nil && entry.driverStandings != nil){
                VStack(spacing:0){
                    HStack{
                        Image(systemName: "star")
                        Text("\(entry.driverStandings!.positionText)")
                    }
                    DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true, condensed: true)
                        .frame(maxHeight:.infinity)
                }
                .frame(maxWidth: .infinity, maxHeight:.infinity)
                
            }
            if(entry.constructorStandings != nil){
                VStack(spacing:0){
                    HStack {
                        Image(systemName: "star")
                        Text("\(entry.constructorStandings!.positionText)")
                    }
                    ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true, condensed: true)
                        .frame(maxHeight:.infinity)
                }
                .frame(maxWidth: .infinity, maxHeight:.infinity)
            }
            if(entry.driverStandings == nil && entry.constructorStandings == nil){
                VStack{
                    Image(systemName: "star")
                    Spacer()
                    Text("No data available")
                        .frame(maxHeight:.infinity)
                }
                .frame(maxWidth: .infinity, maxHeight:.infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight:.infinity)
    }
}
