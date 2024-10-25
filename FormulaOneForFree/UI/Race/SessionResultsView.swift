//
//  SessionResultsView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 20/10/2024.
//

import SwiftUI

struct SessionResultsView: View {
    @State var loading = true
    @State var title: String
    @State var session: Session
    @State var positions: [Position]
    @State var drivers: [Driver]
    @State var results: [Result]
    
    init(session: Session, drivers: [Driver], results: [Result])
    {
        _title = State(initialValue: session.session_name)
        _session = State(initialValue: session)
        _positions = State(initialValue: [])
        _drivers = State(initialValue: drivers)
        _results = State(initialValue: results)
    }
    
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
                NavigationStack {
                    List($positions) {
                        let position = $0.wrappedValue
                        let driver = $drivers.wrappedValue.first(where: {$0.driver_number == position.driver_number})
                        let driverUrl = driver?.headshot_url
                        let driverName = driver?.broadcast_name
                        let teamName = driver?.team_name
                        let teamColor = driver?.team_colour
                        
                        let status = $results.wrappedValue.filter({$0.position == String(position.position)}).first?.status
                        
                        SessionResultItemView(positions: position.position, driverUrl: driverUrl, driverName: driverName ?? "John Doe", team: teamName, teamColor: teamColor, bestLapDuration: position.best_lap?.lap_duration, sessionDuration: position.duration, status: status)
                    }
                    .navigationBarTitle(title)
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

#Preview() {
    SessionResultsView(session: Session(circuit_key: 1, circuit_short_name: "C", country_code: "FRA", country_key: 1, country_name: "FRANCE", date_start: Date(), gmt_offset: "00:00:00Z", location: "d", meeting_key: 1, session_key: 1, session_name: "Sprint", session_type: "Sprint", year: 2024), drivers: [], results: [])
}
