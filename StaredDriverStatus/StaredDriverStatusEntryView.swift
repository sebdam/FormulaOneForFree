//
//  StaredDriverStatusEntryView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 02/11/2024.
//
import Foundation
import SwiftUI
import WidgetKit

struct staredDriverStatusEntryView : View {
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
            if(entry.driver != nil && entry.driverStandings != nil){
                HStack{
                    Image(systemName: "star")
                    Text("\(entry.driverStandings!.positionText)")
                }
                .font(.caption)
                
                Spacer()
                
                DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true, image:entry.driverImage)
            }
            
            if(entry.driverStandings == nil){
                Image(systemName: "star")
                Spacer()
                Text("No data available")
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "arrow.trianglehead.clockwise")
                    .font(.caption2)
                Text(staredDriverStatusEntryView.dateFormatter.string(from: entry.date))
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
            if(entry.driver != nil && entry.driverStandings != nil){
                HStack{
                    Image(systemName: "star")
                    Text("\(entry.driverStandings!.positionText)")
                }
                .font(.caption)
                
                Spacer()
                
                DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true, image:entry.driverImage, condensed: true)
            }
            if(entry.driverStandings == nil){
                Image(systemName: "star")
                Spacer()
                Text("No data available")
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "arrow.trianglehead.clockwise")
                    .font(.caption2)
                Text(staredDriverStatusEntryView.dateFormatter.string(from: entry.date))
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
    }
}


struct AccessoryRectangularDriverStatusEntryView : View {
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        VStack {
            if(entry.driver != nil && entry.driverStandings != nil){
                HStack{
                    Image(systemName: "star")
                    Text("\(entry.driverStandings!.positionText)")
                }
                .font(.caption)
                
                DriverStandingView(driverStanding: .constant(entry.driverStandings!), driver: .constant(entry.driver!), forWidget: true, image:entry.driverImage, condensed: true)
            }
            if(entry.driverStandings == nil){
                Image(systemName: "star")
                Spacer()
                Text("No data available")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
