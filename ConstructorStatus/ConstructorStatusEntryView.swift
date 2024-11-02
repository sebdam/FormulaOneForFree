//
//  ConstructorStatusEntryView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 01/11/2024.
//
import Foundation
import SwiftUI
import WidgetKit

struct constructorStatusEntryView : View {
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
            HStack {
                if(entry.constructorStandings != nil){
                    ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true, image:entry.constructorImage)
                }
                
                if(entry.constructorStandings == nil){
                    Text("No data available")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "arrow.trianglehead.clockwise")
                    .font(.caption2)
                Text(constructorStatusEntryView.dateFormatter.string(from: entry.date))
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
            HStack {
                if(entry.constructorStandings != nil){
                    ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!),
                                            forWidget: true, image:entry.constructorImage, condensed: true)
                }
                if(entry.constructorStandings == nil){
                    Text("No data available")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "arrow.trianglehead.clockwise")
                    .font(.caption2)
                Text(constructorStatusEntryView.dateFormatter.string(from: entry.date))
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
    }
}


struct AccessoryRectangularConstructorStatusEntryView : View {
    var entry: WidgetTimeLineProvider.Entry
    
    var body: some View {
        HStack {
            if(entry.constructorStandings != nil){
                ConstructorStandingView(constructorStanding: .constant(entry.constructorStandings!), forWidget: true, image:entry.constructorImage, condensed: true)
            }
            if(entry.constructorStandings == nil){
                Text("No data available")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
