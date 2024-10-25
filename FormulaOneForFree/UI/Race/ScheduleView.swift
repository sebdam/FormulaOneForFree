//
//  ScheduleView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 19/10/2024.
//

import SwiftUI

struct ScheduleView: View {
    @Binding var dueDate: Date?
    @State var scheduleName = "Name"
    @State private var duration = ""
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    static var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter
    }()
    
    var body: some View {
        HStack {
            //Overdue
            if(dueDate != nil && Date().timeIntervalSince(dueDate!) > 0){
                Image(systemName: "checkmark.square").foregroundStyle(.green).padding([.leading])
            }
            else if(dueDate != nil){
                Image(systemName: "timer").foregroundStyle(.green)
            }
            else {
                Image(systemName: "questionmark.circle").foregroundStyle(.red)
            }
            
            Text(scheduleName)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if(dueDate != nil && Date().timeIntervalSince(dueDate!) <= 0){
                Text(duration).font(.footnote)
                    .frame(maxWidth: .infinity)
            }
        }
        .onReceive(timer) { _ in
            computeDurations()
        }
    }
    
    private func computeDurations() {
        if(dueDate != nil){
            let delta = dueDate!.timeIntervalSince(Date())
            duration = ScheduleView.durationFormatter.string(from: delta)!
        }
        else {
            duration = ""
        }
    }
}

#Preview("overdue") {
    ScheduleView(dueDate: Binding<Date?>.constant(Calendar.current.date(byAdding: .day, value: -2, to: Date())) , scheduleName: "OD")
}

#Preview("future") {
    ScheduleView(dueDate: Binding<Date?>.constant(Calendar.current.date(byAdding: .day, value: 2, to: Date())), scheduleName: "NEXT")
}

#Preview("cancel") {
    ScheduleView(dueDate: Binding<Date?>.constant(nil as Date?), scheduleName: "CAN")
}
