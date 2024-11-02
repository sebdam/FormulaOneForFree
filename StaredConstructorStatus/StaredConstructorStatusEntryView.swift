//
//  StaredConstructorStatusEntryView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 02/11/2024.
//
import Foundation
import SwiftUI
import WidgetKit

struct staredConstructorStatusEntryView : View {
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
            case .systemMedium: MediumConstructorStatusEntryView(entry:entry)
            case .systemSmall: SmallConstructorStatusEntryView(entry:entry)
            case .systemLarge: MediumConstructorStatusEntryView(entry:entry)
            case .accessoryRectangular: AccessoryRectangularConstructorStatusEntryView(entry:entry)
            default: SmallConstructorStatusEntryView(entry:entry)
        }
    }
}

struct MediumConstructorStatusEntryView : View {
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        VStack {
            if(entry.driver != nil && entry.driverStandings != nil){
                HStack {
                    Image(systemName: "star")
                    Text("\(entry.constructorStandings!.positionText)")
                }
                .font(.caption)
                
                Spacer()
                
                ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true, image:entry.constructorImage)
            }
            
            if(entry.constructorStandings == nil){
                Text("No data available")
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "arrow.trianglehead.clockwise")
                    .font(.caption2)
                Text(staredConstructorStatusEntryView.dateFormatter.string(from: entry.date))
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
    }
}

struct SmallConstructorStatusEntryView : View {
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        VStack {
            if(entry.constructorStandings != nil){
                HStack {
                    Image(systemName: "star")
                    Text("\(entry.constructorStandings!.positionText)")
                }
                .font(.caption)
                
                Spacer()
                
                ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!),
                                        forWidget: true, image:entry.constructorImage, condensed: true)
            }
            if(entry.constructorStandings == nil){
                Image(systemName: "star")
                Spacer()
                Text("No data available")
            }
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "arrow.trianglehead.clockwise")
                    .font(.caption2)
                Text(staredConstructorStatusEntryView.dateFormatter.string(from: entry.date))
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
    }
}


struct AccessoryRectangularConstructorStatusEntryView : View {
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        VStack {
            if(entry.driver != nil && entry.driverStandings != nil){
                HStack {
                    Image(systemName: "star")
                    Text("\(entry.constructorStandings!.positionText)")
                }
                .font(.caption)
                ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true, image:entry.constructorImage, condensed: true)
            }
            if(entry.constructorStandings == nil){
                Image(systemName: "star")
                Spacer()
                Text("No data available")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
