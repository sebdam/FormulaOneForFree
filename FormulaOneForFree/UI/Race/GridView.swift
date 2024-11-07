//
//  GridView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 27/10/2024.
//

import SwiftUI

struct GridView: View {
    @State var loading = true
    @State var session: Session
    @State var positions: [Position] = []
    @State var drivers: [Driver] = []
    var body: some View {
        if(loading){
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }.onAppear() {
                LoadSessionData()
            }
        } else {
            ScrollView(.vertical, showsIndicators: false){
                let orderedPositions = $positions.wrappedValue.sorted { $0.position < $1.position }
                let pairs = stride(from: 0, to: orderedPositions.endIndex, by: 2).map {
                    (orderedPositions[$0], $0 < orderedPositions.index(before: orderedPositions.endIndex) ? orderedPositions[$0.advanced(by: 1)] : nil)
                }
                
                LazyVStack {
                    VStack(spacing:0) {
                        let squareNumber: Int = 10
                        let width = UIScreen.main.bounds.width/(2.0*Double(squareNumber))
                        HStack(spacing:width) {
                            ForEach(0..<squareNumber){ index in
                                Rectangle()
                                    .fill(.foreground.opacity(1))
                                    .frame(width:width, height:width)
                            }
                        }
                        HStack(spacing:width) {
                            ForEach(0..<squareNumber){ index in
                                Rectangle()
                                    .fill(.background.opacity(1))
                                    .frame(width:width, height:width)
                            }
                        }.background(.foreground.opacity(1))
                        HStack(spacing:width) {
                            ForEach(0..<squareNumber){ index in
                                Rectangle()
                                    .fill(.foreground.opacity(1))
                                    .frame(width:width, height:width)
                            }
                        }
                        
                    }
                    .border(.foreground.opacity(1), width: 2)
                    
                    ForEach(0..<pairs.count){ i in
                        HStack {
                            let firstDriver = drivers.first(where: {$0.driver_number == pairs[i].0.driver_number})
                            if(firstDriver != nil){
                                DriverView(driver: firstDriver!,
                                           bestLapDuration: pairs[i].0.best_lap?.lap_duration,
                                           position: String(pairs[i].0.position),
                                           alignBottom: false)
                            }
                            
                            if(pairs[i].1 != nil){
                                let secondDriver = drivers.first(where: {$0.driver_number == pairs[i].1!.driver_number})
                                DriverView(driver: secondDriver!,
                                           bestLapDuration: pairs[i].1!.best_lap?.lap_duration,
                                           position: String(pairs[i].1!.position),
                                           alignBottom: false)
                                    .padding([.top], 60)
                            }
                            else {
                                Spacer().frame(maxHeight: .infinity)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func LoadSessionData() {
        loading = true
        Task { @MainActor in
            let openF1Repo = OpenF1Repository()
            let newSession = await openF1Repo.LoadSessionData(session: $session.wrappedValue)
            self.$session.wrappedValue.positions = newSession.positions
            self.$positions.wrappedValue = newSession.positions ?? []
            
            loading = false
        }
    }
}

#Preview {
    GridView(loading: false,
             session: Session(circuit_key: 1, circuit_short_name: "C", country_code: "FRA", country_key: 1, country_name: "FRANCE", date_start: Date(), date_end: Date(), gmt_offset: "00:00:00Z", location: "d", meeting_key: 1, session_key: 1, session_name: "Sprint", session_type: "Sprint", year: 2024),
             positions: [
                Position(date: Date(), driver_number: 42, meeting_key: 42, session_key: 42, position: 1),
                Position(date: Date(), driver_number: 33, meeting_key: 42, session_key: 42, position: 2),
                Position(date: Date(), driver_number: 43, meeting_key: 42, session_key: 42, position: 3),
                Position(date: Date(), driver_number: 44, meeting_key: 42, session_key: 42, position: 4),
                Position(date: Date(), driver_number: 45, meeting_key: 42, session_key: 42, position: 5)],
             drivers: [
              Driver(broadcast_name: "SDC42", country_code: "FRA", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "https://www.formula1.com/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png.transform/1col/image.png", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"),
              Driver(broadcast_name: "SDC33", country_code: "FRA", driver_number: 33, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "https://www.formula1.com/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png.transform/1col/image.png", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"),
              Driver(broadcast_name: "SDC43", country_code: "FRA", driver_number: 43, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "https://www.formula1.com/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png.transform/1col/image.png", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"),
              Driver(broadcast_name: "SDC44", country_code: "FRA", driver_number: 44, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "https://www.formula1.com/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png.transform/1col/image.png", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"),
              Driver(broadcast_name: "SDC45", country_code: "FRA", driver_number: 45, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "https://www.formula1.com/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png.transform/1col/image.png", last_name: "Damiens-Cerf", meeting_key: 45, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari")
             ])
}
