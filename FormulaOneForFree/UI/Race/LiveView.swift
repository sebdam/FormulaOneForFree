//
//  LiveView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 02/11/2024.
//

import SwiftUI

struct LiveView: View {
    @State var loading: Bool = true
    @Binding var session: Session
    @State var drivers: [Driver]
    @State var multiCircuit: MultiviewerCircuit?
    
    @State var locations: [DriverLocation]
    
    @State private var replay = false
    @State private var loadingReplay = false
    @State private var replaySpeed = 2.0
    @State private var replayLocations: [DriverLocation] = []
    @State private var lastReplayDate: Date = Date()
    
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    var body: some View {
        if(loading){
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }.onAppear(){
                LoadSessionData()
            }
            .onChange(of: session, initial: true){ oldValue, newValue in
                print("Session changed")
                print("positions: \(session.positions?.count ?? 0)")
            }
        } else if(multiCircuit != nil) {
            VStack {
                if(session.date_end < Date()){
                    HStack {
                        Button("",
                               systemImage: "chevron.right.dotted.chevron.right",
                               action: slowDown)
                        Spacer()
                        Button("",
                               systemImage: loadingReplay ? "hourglass.circle" : replay ? "play.fill" : "play",
                               action: startStopReplay)
                            .disabled(loadingReplay)
                        Spacer()
                        Button("",
                               systemImage: "chevron.forward.2",
                               action: speedUp)
                        Spacer()
                        Text($replaySpeed.wrappedValue, format: .number.precision(.fractionLength(0)))
                        Text("x")
                        Spacer()
                        Text("\(LiveView.dateFormatter.string(from: $lastReplayDate.wrappedValue))")
                        Spacer()
                    }
                }
                
                ZStack {
                        
                    var offsetX: Double = 0
                    var offsetY: Double = 0
                    var scaleRatio: Double = 1
                    let flipX = true
                    let flipY = false
                    let margin = 5.0
                    let trackLineWidth = 10.0
                    let pointSize = 18.0

                    Canvas { ctx, size in
                        var points = [CGPoint]()
                        
                        //Compute points with circuit rotation
                        for(index,x) in multiCircuit!.x.enumerated(){
                            points.append(CGPoint(x: x, y: multiCircuit!.y[index]).rotate(angle: multiCircuit!.rotation, flipX: flipX, flipY: flipY))
                        }
                        
                        //Create path
                        var path = Path()
                        path.addLines(points)
                        
                        offsetX = -1.0 * path.boundingRect.origin.x
                        offsetY = -1.0 * path.boundingRect.origin.y
                        
                        //Move on top left corner
                        let centeredPath = path.applying(CGAffineTransform(translationX: offsetX, y: offsetY))
                        
                        //compute scale ratio
                        scaleRatio = 1.0 / max(centeredPath.boundingRect.width / (size.width - (2 * margin)), centeredPath.boundingRect.height / (size.height - (2 * margin)))
                        
                        let scaleShape = centeredPath
                            //Scale
                            .applying(CGAffineTransform(scaleX: scaleRatio, y: scaleRatio))
                            //margin
                            .applying(CGAffineTransform(translationX: margin, y: margin))
                        ctx.stroke(scaleShape, with: .style(.foreground), lineWidth: trackLineWidth)
                    }
                    .padding()
                    
                    ForEach(locations) { location in
                        Canvas { ctx, size in
                            
                            let rect = CGRect(origin: CGPoint(x:location.x, y:location.y)
                                .rotate(angle: multiCircuit!.rotation, flipX: flipX, flipY: flipY),
                                              size: CGSizeMake(pointSize/scaleRatio, pointSize/scaleRatio))
                            
                            let path = Circle().path(in: rect)
                            
                            //Move on top left corner
                            let centeredPath = path.applying(CGAffineTransform(translationX: offsetX, y: offsetY))
                            
                            let scaleShape = centeredPath
                                //Scale
                                .applying(CGAffineTransform(scaleX: scaleRatio, y: scaleRatio))
                                //margin and point size center
                                .applying(CGAffineTransform(translationX: margin-(pointSize/2.0), y: margin-(pointSize/2.0)))

                            var color: Color = .red
                            if(location.driver?.team_colour != nil){
                                color = Color.init(hex: location.driver!.team_colour!)!.opacity(1)
                            }

                            ctx.fill(scaleShape, with: .color(color))

                        }
                        .padding()
                    }
                    
                }
                .onReceive(timer) { _ in
                    Task { @MainActor in
                        if(session.date_start < Date() && session.date_end > Date()) {
                            await LoadPoints()
                        }
                        else if(session.date_end < Date() && replay){
                            await LoadReplayPoints()
                        }
                    }
                }
            }
        }
    }
    
    private func LoadSessionData() {
        loading = true
        Task { @MainActor in
            let multiRepo = MultiviewerRepository()
            self.$multiCircuit.wrappedValue = await multiRepo.GetCircuit(forYear: session.year, key: session.circuit_key)
            
            loading = false
        }
    }
    
    private func LoadPoints() async {
        let repo = OpenF1Repository()
        let positions = await repo.GetDriversLocations(meetingKey: session.meeting_key, sessionKey: session.session_key, since: Calendar.current.date(byAdding: .second, value: -1, to: Date())!)

        var finalPositions: [DriverLocation] = []
        
        if(positions != nil){
            let ordered = positions!
                .filter({$0.x != 0 && $0.y != 0})
                .sorted(by: {$0.date ?? Date() > $1.date ?? Date() })
            
            for driver in drivers {
                let driverPosition = ordered.first(where: {$0.driver_number == driver.driver_number})
                if(driverPosition != nil){
                    var newPosition = driverPosition!
                    newPosition.driver = driver
                    finalPositions.append(newPosition)
                }
            }
            
            self.$locations.wrappedValue.removeAll()
            self.$locations.wrappedValue.append(contentsOf: finalPositions)
        }
    }
    
    func startStopReplay(){
        Task { @MainActor in
            
            if(replay || replayLocations.count > 0){
                replay.toggle()
                return
            }

            if(replayLocations.count == 0){
                loadingReplay.toggle()
                
                var driver = session.positions?[0].driver_number
                if(driver == nil){
                    loadingReplay.toggle()
                    return
                }
                
                let repo = OpenF1Repository()
                var positions = await repo.GetDriversLocations(meetingKey: session.meeting_key, sessionKey: session.session_key, driverNumber: driver!, since: session.date_start, to: session.date_end)
                
                replayLocations = positions ?? []
                
                try await Task.sleep(nanoseconds: UInt64(1.0 * Double(NSEC_PER_SEC)))
                
                driver = session.positions?[1].driver_number
                positions = await repo.GetDriversLocations(meetingKey: session.meeting_key, sessionKey: session.session_key, driverNumber: driver!, since: session.date_start, to: session.date_end)
                replayLocations.append(contentsOf: positions ?? [])
                
                try await Task.sleep(nanoseconds: UInt64(1.0 * Double(NSEC_PER_SEC)))
                driver = session.positions?[2].driver_number
                positions = await repo.GetDriversLocations(meetingKey: session.meeting_key, sessionKey: session.session_key, driverNumber: driver!, since: session.date_start, to: session.date_end)
                replayLocations.append(contentsOf: positions ?? [])
                
                if(replayLocations.count > 0){
                    lastReplayDate = session.date_start
                    replay.toggle()
                }
                
                loadingReplay.toggle()
            }
        }
    }
    
    func speedUp(){
        replaySpeed += 1
    }
    
    func slowDown(){
        if(replaySpeed>1) {
            replaySpeed -= 1
        }
    }
    
    private func LoadReplayPoints() async {
        
        var finalPositions: [DriverLocation] = []
        
        let oneSecPositions = replayLocations.filter({$0.date ?? Date() >= lastReplayDate && $0.date ?? Date() < lastReplayDate.addingTimeInterval(0.5)})

        let ordered = oneSecPositions
            .filter({$0.x != 0 && $0.y != 0})
            .sorted(by: {$0.date ?? Date() > $1.date ?? Date() })

        for driver in drivers {
            let driverPosition = ordered.first(where: {$0.driver_number == driver.driver_number})
            if(driverPosition != nil){
                var newPosition = driverPosition!
                newPosition.driver = driver
                finalPositions.append(newPosition)
            }
        }
        
        lastReplayDate = lastReplayDate.addingTimeInterval(replaySpeed * 0.5)

        self.$locations.wrappedValue.removeAll()
        self.$locations.wrappedValue.append(contentsOf: finalPositions)
        
    }
}

#Preview {
    LiveView(session:.constant(Session(circuit_key: 19, circuit_short_name: "C", country_code: "FRA", country_key: 1, country_name: "FRANCE",
                              date_start: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                              date_end: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                              gmt_offset: "00:00:00Z", location: "d", meeting_key: 1249, session_key: 9635, session_name: "Sprint", session_type: "Sprint", year: 2024, positions: [])),
             drivers: [
                Driver(broadcast_name: "M Verstappen", country_code:"", driver_number: 81, first_name:"Max", full_name: "Max Verstappen", headshot_url: "", last_name: "Verstappen", meeting_key: 1, name_acronym:"VER", session_key:1, team_colour:"FF0000", team_name: "Red Bull Racing"),
                Driver(broadcast_name: "M Verstappen", country_code:"", driver_number: 2, first_name:"Max", full_name: "Max Verstappen", headshot_url: "", last_name: "Verstappen", meeting_key: 1, name_acronym:"VER", session_key:1, team_colour:"0000FF", team_name: "Red Bull Racing"),
                Driver(broadcast_name: "M Verstappen", country_code:"", driver_number: 3, first_name:"Max", full_name: "Max Verstappen", headshot_url: "", last_name: "Verstappen", meeting_key: 1, name_acronym:"VER", session_key:1, team_colour:"FF0000", team_name: "Red Bull Racing")
             ],
             locations: [
                DriverLocation(date: DateFormatter().date(from:"2024-11-02T14:09:21Z0000"), driver_number: 1, meeting_key: 1249, session_key: 9635, x: 0, y: 0, z: 0, driver: Driver(broadcast_name: "M Verstappen", country_code:"", driver_number: 1, first_name:"Max", full_name: "Max Verstappen", headshot_url: "", last_name: "Verstappen", meeting_key: 1, name_acronym:"VER", session_key:1, team_colour:"0000FF", team_name: "Red Bull Racing"))
                ]
    )
}
