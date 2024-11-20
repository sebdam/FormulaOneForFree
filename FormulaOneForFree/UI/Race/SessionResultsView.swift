//
//  SessionResultsView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 20/10/2024.
//

import SwiftUI

struct SessionResultsView: View {
    @State var loading: Bool
    @State var title: String
    @State var session: Session
    @State var positions: [Position]
    @State var drivers: [Driver]
    @State var results: [Result]
    
    @State private var prevOrientation: UIDeviceOrientation
    @State private var orientation: UIDeviceOrientation
    
    init(loading: Bool = true, session: Session, drivers: [Driver], results: [Result])
    {
        _loading = State(initialValue: loading)
        _title = State(initialValue: session.session_name)
        _session = State(initialValue: session)
        _positions = State(initialValue: session.positions ?? [])
        _drivers = State(initialValue: drivers)
        _results = State(initialValue: results)
        
        _prevOrientation = State(initialValue: UIDevice.current.orientation)
        _orientation = State(initialValue: UIDevice.current.orientation)
    }
    
    private func GetPositionsList() -> List<Never, ForEach<Binding<[Position]>, Binding<Position>.ID, SessionResultItemView>> {
        return List($positions) {
            let position = $0.wrappedValue
            let driver = $drivers.wrappedValue.first(where: {$0.driver_number == position.driver_number})
            let driverUrl = driver?.headshot_url
            let driverName = driver?.broadcast_name
            let teamName = driver?.team_name
            let teamColor = driver?.team_colour
            
            let status = $results.wrappedValue.filter({$0.position == String(position.position)}).first?.status
            
            SessionResultItemView(positions: position.position, driverUrl: driverUrl, driverName: driverName ?? "John Doe", team: teamName, teamColor: teamColor, bestLapDuration: position.best_lap?.lap_duration, sessionDuration: position.duration, status: status)
        }
    }
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
            if(loading){
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .onAppear() {
                    LoadSessionData()
                }
            } else {
                NavigationStack {
                    if(orientation.isLandscape || (orientation.isFlat && prevOrientation.isLandscape)){
                        HStack{
                            LiveView(session:$session, drivers: drivers, locations: [])
                                    .padding([.top])
                                Spacer()
                            
                            GetPositionsList().navigationBarTitle(title)
                        }
                    }
                    else {
                        GetPositionsList()
                        .navigationBarTitle(title)
                    }
                }
                .onRotate { newOrientation in
                    prevOrientation = orientation
                    orientation = newOrientation
                }
                .onReceive(timer) { _ in
                    Task { @MainActor in
                        if(session.date_start < Date() && session.date_end > Date()) {
                            LoadPositions()
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
            
            self.session = newSession
            if(newSession.positions != nil){
                self.positions = newSession.positions!
            }
            
            loading = false
        }
    }
    
    private func LoadPositions() {
        Task { @MainActor in
            let openF1Repo = OpenF1Repository()
            let newPositions = await openF1Repo.GetPostions(meetingKey: $session.wrappedValue.meeting_key, sessionKey: $session.wrappedValue.session_key)
            
            if(newPositions != nil){
                self.session.positions = newPositions!
                self.positions = newPositions!
            }
            
        }
    }
    
}

#Preview() {
    SessionResultsView(loading: false,
                       session: Session(circuit_key: 14, circuit_short_name: "C", country_code: "FRA", country_key: 1, country_name: "FRANCE",
                                        date_start: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                                        date_end: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                                        gmt_offset: "00:00:00Z", location: "d", meeting_key: 1249, session_key: 9635, session_name: "Sprint", session_type: "Sprint", year: 2024,
                                        positions: [
                                            Position(date: Date(), driver_number: 1, meeting_key: 1, session_key: 1, position: 1, laps: [
                                                Lap(date_start: Date(), driver_number: 1, duration_sector_1: 1, duration_sector_2: 2, duration_sector_3: 3, i1_speed: 1, i2_speed: 1, is_pit_out_lap: false, lap_duration: 1, lap_number: 1, meeting_key: 1, session_key: 1, st_speed: 1)
                                            ])
                                        ]),
                       drivers: [], results: [])
}
