//
//  RaceDetailView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 24/10/2024.
//

import SwiftUI
import CachedAsyncImage

struct RaceDetailView: View {
    @Binding var race: Race
    @Binding var meeting: Meeting?
    @State var drivers: [Driver] = []
    
    @State var loading = false
    
    @State var trackImageId = UUID()
    
    
    @State private var prevOrientation: UIDeviceOrientation = UIDeviceOrientation.portrait
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    var body: some View {
        if(loading){
            VStack {
                ProgressView()
                Text("Loading data ...")
            }
        }
        else {
            VStack {
                if(orientation.isPortrait || (orientation.isFlat && prevOrientation.isPortrait))
                {
                    VStack {
                        HStack {
                            Text($race.wrappedValue.season)
                            
                            Text($race.wrappedValue.raceName)
                                .font(.title2)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(maxWidth:.infinity)
                        }.clipShape(.rect(cornerRadius: 12))
                        
                        
                        CachedAsyncImage(url: URL(string: FormulaOneRepository.GetCircuitImageUrl($race.wrappedValue.Circuit))) { phase in
                            if let image = phase.image {
                                image.resizable()
                            } else if phase.error != nil {
                                ContentUnavailableView(label: {
                                    Image(systemName: "photo")
                                        .font(.title)
                                        .foregroundStyle(.secondary)
                                }, actions: {
                                    Button(action: { trackImageId = UUID() }, label: {Label("retry", systemImage: "arrow.counterclockwise")})
                                })
                            } else {
                                ProgressView()
                            }
                        }
                        .id(trackImageId)
                        .aspectRatio(contentMode: .fit)
                        
                        let qualifSession = meeting?.sessions?.first(where: {$0.session_name == "Qualifying"})
                        List {
                            if($race.wrappedValue.FirstPractice != nil){
                                let session = meeting?.sessions?.first(where: {$0.session_name == "Practice 1"})
                                if(session != nil){
                                    NavigationLink() {
                                        SessionResultsView(session: session!, drivers: drivers, results: [])
                                    } label: {
                                        ScheduleView(dueDate: .constant($race.wrappedValue.FirstPractice?.datetime), scheduleName: "Practice 1", haveSession: true)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                } else {
                                    ScheduleView(dueDate: .constant($race.wrappedValue.FirstPractice?.datetime), scheduleName: "Practice 1")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            if($race.wrappedValue.SecondPractice != nil){
                                let session = meeting?.sessions?.first(where: {$0.session_name == "Practice 2"})
                                if(session != nil){
                                    NavigationLink() {
                                        SessionResultsView(session: session!, drivers: drivers, results: [])
                                    } label: {
                                        ScheduleView(dueDate: .constant($race.wrappedValue.SecondPractice?.datetime), scheduleName: "Practice 2", haveSession: true)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                else {
                                    ScheduleView(dueDate: .constant($race.wrappedValue.SecondPractice?.datetime), scheduleName: "Practice 2")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            if($race.wrappedValue.ThirdPractice != nil){
                                let session = meeting?.sessions?.first(where: {$0.session_name == "Practice 3"})
                                if(session != nil){
                                    NavigationLink() {
                                        SessionResultsView(session: session!, drivers: drivers, results: [])
                                    } label: {
                                        ScheduleView(dueDate: .constant($race.wrappedValue.ThirdPractice?.datetime), scheduleName: "Practice 3", haveSession: true)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                else {
                                    ScheduleView(dueDate: .constant($race.wrappedValue.ThirdPractice?.datetime), scheduleName: "Practice 3")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            if($race.wrappedValue.SprintQualifying != nil){
                                let session = meeting?.sessions?.first(where: {$0.session_name == "Sprint Qualifying"})
                                if(session != nil){
                                    NavigationLink() {
                                        GridView(session: session!, drivers: drivers)
                                    } label: {
                                        ScheduleView(dueDate: .constant($race.wrappedValue.SprintQualifying?.datetime), scheduleName: "Sprint Qualifying", haveSession: true)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                else {
                                    ScheduleView(dueDate: .constant($race.wrappedValue.SprintQualifying?.datetime), scheduleName: "Sprint Qualifying")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            if($race.wrappedValue.Sprint != nil){
                                let session = meeting?.sessions?.first(where: {$0.session_name == "Sprint"})
                                if(session != nil){
                                    NavigationLink() {
                                        SessionResultsView(session: session!, drivers: drivers, results: race.Results ?? [])
                                    } label: {
                                        ScheduleView(dueDate: .constant($race.wrappedValue.Sprint?.datetime), scheduleName: "Sprint", haveSession: true)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                else {
                                    ScheduleView(dueDate: .constant($race.wrappedValue.Sprint?.datetime), scheduleName: "Sprint")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            
                            if($race.wrappedValue.Qualifying != nil){
                                if(qualifSession != nil){
                                    NavigationLink() {
                                        GridView(session: qualifSession!, drivers: drivers)
                                    } label: {
                                        ScheduleView(dueDate: .constant($race.wrappedValue.Qualifying?.datetime), scheduleName: "Qualifying", haveSession: true)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                else {
                                    ScheduleView(dueDate: .constant($race.wrappedValue.Qualifying?.datetime), scheduleName: "Qualifying")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            
                            let session = meeting?.sessions?.first(where: {$0.session_name == "Race"})
                            if(session != nil){
                                NavigationLink() {
                                    SessionResultsView(session: session!, drivers: drivers, results: race.Results ?? [])
                                } label: {
                                    ScheduleView(dueDate:Binding<Date?>.constant($race.wrappedValue.datetime), scheduleName: "Race", haveSession: true)
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            else {
                                ScheduleView(dueDate:Binding<Date?>.constant($race.wrappedValue.datetime), scheduleName: "Race")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .listStyle(.plain)
                        
                        
                        if($race.wrappedValue.Results?.count ?? 0 == 0 && qualifSession != nil){
                            GridView(session: qualifSession!, drivers: drivers)
                        }
                        
                        
                        if($race.wrappedValue.Results?.count ?? 0 >= 3) {
                            HStack {
                                let resultSecond = $race.wrappedValue.Results?.first(where: {$0.position == "2"})
                                let driverSecond = $drivers.wrappedValue.first(where: {$0.name_acronym == resultSecond?.Driver.code})
                                DriverView(driver: driverSecond!,
                                           position: "2",
                                           height: 20)
                                .frame(maxWidth:.infinity)
                                
                                let resultFirst = $race.wrappedValue.Results?.first(where: {$0.position == "1"})
                                let driverFirst = $drivers.wrappedValue.first(where: {$0.name_acronym == resultFirst?.Driver.code})
                                DriverView(driver: driverFirst!,
                                           position: "1",
                                           height: 40)
                                .frame(maxWidth:.infinity)
                                
                                let resultThird = $race.wrappedValue.Results?.first(where: {$0.position == "3"})
                                let driverThird = $drivers.wrappedValue.first(where: {$0.name_acronym == resultThird?.Driver.code})
                                DriverView(driver: driverThird!,
                                           position: "3",
                                           height: nil)
                                .frame(maxWidth:.infinity)
                                
                            }
                        }
                    }
                    .padding()
                    .cornerRadius(12)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.blue, lineWidth: 2)
                    )
                }
                else {
                    HStack {
                        let qualifSession = meeting?.sessions?.first(where: {$0.session_name == "Qualifying"})
                        
                        VStack {
                            HStack {
                                Text($race.wrappedValue.season)
                                
                                Text($race.wrappedValue.raceName)
                                    .font(.title2)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .frame(maxWidth:.infinity)
                            }
                            
                            CachedAsyncImage(url: URL(string: FormulaOneRepository.GetCircuitImageUrl($race.wrappedValue.Circuit))) { phase in
                                if let image = phase.image {
                                    image.resizable()
                                } else if phase.error != nil {
                                    ContentUnavailableView(label: {
                                        Image(systemName: "photo")
                                            .font(.title)
                                            .foregroundStyle(.secondary)
                                    }, actions: {
                                        Button(action: { trackImageId = UUID() }, label: {Label("retry", systemImage: "arrow.counterclockwise")})
                                    })
                                } else {
                                    ProgressView()
                                }
                            }
                            .id(trackImageId)
                            .aspectRatio(contentMode: .fit)
                            
                            if($race.wrappedValue.Results?.count ?? 0 == 0 && qualifSession != nil){
                                GridView(session: qualifSession!, drivers: drivers)
                                    .frame(maxHeight: .infinity)
                            }
                            else if($race.wrappedValue.Results?.count ?? 0 >= 3) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        let resultFirst = $race.wrappedValue.Results?.first(where: {$0.position == "1"})
                                        let driverFirst = $drivers.wrappedValue.first(where: {$0.name_acronym == resultFirst?.Driver.code})!
                                        
                                        DriverView(driver: driverFirst, position: "1", height: nil, alignBottom: false, showTeam: false)
                                        
                                        Divider()
                                        
                                        let resultSecond = $race.wrappedValue.Results?.first(where: {$0.position == "2"})
                                        let driverSecond = $drivers.wrappedValue.first(where: {$0.name_acronym == resultSecond?.Driver.code})!
                                        DriverView(driver: driverSecond, position: "2", height: nil, alignBottom: false, showTeam: false)
                                        
                                        Divider()
                                        
                                        let resultThird = $race.wrappedValue.Results?.first(where: {$0.position == "3"})
                                        let driverThird = $drivers.wrappedValue.first(where: {$0.name_acronym == resultThird?.Driver.code})!
                                        DriverView(driver: driverThird, position: "3", height: nil, alignBottom: false, showTeam: false)
                                        
                                        Divider()
                                        
                                        DriverView(driver: driverFirst, position: "1", height: nil, alignBottom: false, showDriver: false, showTeam: true)
                                        
                                        Divider()
                                        
                                        DriverView(driver: driverSecond, position: "2", height: nil, alignBottom: false, showDriver: false, showTeam: true)
                                        
                                        Divider()
                                        
                                        DriverView(driver: driverThird, position: "3", height: nil, alignBottom: false, showDriver: false, showTeam: true)

                                    }
                                    .scrollTargetLayout()
                                }
                                .scrollTargetBehavior(.viewAligned)
                                
                            }
                            
                        }
                        .clipShape(.rect(cornerRadius: 12))
                        
                        List {
                            if($race.wrappedValue.FirstPractice != nil){
                                let session = meeting?.sessions?.first(where: {$0.session_name == "Practice 1"})
                                if(session != nil){
                                    NavigationLink() {
                                        SessionResultsView(session: session!, drivers: drivers, results: [])
                                    } label: {
                                        ScheduleView(dueDate: .constant($race.wrappedValue.FirstPractice?.datetime), scheduleName: "Practice 1", haveSession: true)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                } else {
                                    ScheduleView(dueDate: .constant($race.wrappedValue.FirstPractice?.datetime), scheduleName: "Practice 1")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            if($race.wrappedValue.SecondPractice != nil){
                                let session = meeting?.sessions?.first(where: {$0.session_name == "Practice 2"})
                                if(session != nil){
                                    NavigationLink() {
                                        SessionResultsView(session: session!, drivers: drivers, results: [])
                                    } label: {
                                        ScheduleView(dueDate: .constant($race.wrappedValue.SecondPractice?.datetime), scheduleName: "Practice 2", haveSession: true)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                else {
                                    ScheduleView(dueDate: .constant($race.wrappedValue.SecondPractice?.datetime), scheduleName: "Practice 2")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            if($race.wrappedValue.ThirdPractice != nil){
                                let session = meeting?.sessions?.first(where: {$0.session_name == "Practice 3"})
                                if(session != nil){
                                    NavigationLink() {
                                        SessionResultsView(session: session!, drivers: drivers, results: [])
                                    } label: {
                                        ScheduleView(dueDate: .constant($race.wrappedValue.ThirdPractice?.datetime), scheduleName: "Practice 3", haveSession: true)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                else {
                                    ScheduleView(dueDate: .constant($race.wrappedValue.ThirdPractice?.datetime), scheduleName: "Practice 3")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            if($race.wrappedValue.SprintQualifying != nil){
                                let session = meeting?.sessions?.first(where: {$0.session_name == "Sprint Qualifying"})
                                if(session != nil){
                                    NavigationLink() {
                                        GridView(session: session!, drivers: drivers)
                                    } label: {
                                        ScheduleView(dueDate: .constant($race.wrappedValue.SprintQualifying?.datetime), scheduleName: "Sprint Qualifying", haveSession: true)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                else {
                                    ScheduleView(dueDate: .constant($race.wrappedValue.SprintQualifying?.datetime), scheduleName: "Sprint Qualifying")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            if($race.wrappedValue.Sprint != nil){
                                let session = meeting?.sessions?.first(where: {$0.session_name == "Sprint"})
                                if(session != nil){
                                    NavigationLink() {
                                        SessionResultsView(session: session!, drivers: drivers, results: race.Results ?? [])
                                    } label: {
                                        ScheduleView(dueDate: .constant($race.wrappedValue.Sprint?.datetime), scheduleName: "Sprint", haveSession: true)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                else {
                                    ScheduleView(dueDate: .constant($race.wrappedValue.Sprint?.datetime), scheduleName: "Sprint")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            
                            if($race.wrappedValue.Qualifying != nil){
                                if(qualifSession != nil){
                                    NavigationLink() {
                                        GridView(session: qualifSession!, drivers: drivers)
                                    } label: {
                                        ScheduleView(dueDate: .constant($race.wrappedValue.Qualifying?.datetime), scheduleName: "Qualifying", haveSession: true)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                else {
                                    ScheduleView(dueDate: .constant($race.wrappedValue.Qualifying?.datetime), scheduleName: "Qualifying")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            
                            let session = meeting?.sessions?.first(where: {$0.session_name == "Race"})
                            if(session != nil){
                                NavigationLink() {
                                    SessionResultsView(session: session!, drivers: drivers, results: race.Results ?? [])
                                } label: {
                                    ScheduleView(dueDate:Binding<Date?>.constant($race.wrappedValue.datetime), scheduleName: "Race", haveSession: true)
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            else {
                                ScheduleView(dueDate:Binding<Date?>.constant($race.wrappedValue.datetime), scheduleName: "Race")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .listStyle(.plain)
                        .clipShape(.rect(cornerRadius: 12))
                    }
                    .padding()
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.blue, lineWidth: 2)
                    )
                }
            }
            .padding([.trailing, .leading], 35)
            .padding([.top,.bottom])
            .onRotate { newOrientation in
                prevOrientation = orientation
                orientation = newOrientation
            }
        }
    }
}

#Preview {
    RaceDetailView(race: .constant(
        Race( season: "2024", round: "1", url: "", raceName: "Champion 1",
            Circuit: Circuit(circuitId: "42", url: "", circuitName: "Hockenheimring", Location: Location(lat: "", long: "", locality: "", country: "")),
            date: "2024-01-01T00:00:00.000+00:00", time: nil,
            FirstPractice: Schedule(date: "", time: nil),
            SecondPractice: Schedule(date: "", time: nil),
            ThirdPractice: Schedule(date: "", time: nil),
            SprintQualifying: Schedule(date: "", time: nil),
            Sprint: Schedule(date: "", time: nil),
            Qualifying: Schedule(date: "2024-01-01", time: "08:00:00Z"),
             Results: [
                Result(number: "1", position: "1", positionText: "1", points: "442",
                       Driver: JolpyDriver(driverId: "42", url: "", givenName: "Seb Dam", familyName: "Damiens-Cerf", dateOfBirth: "1979-04-25", nationality: "France", permanentNumber: nil, code: "SDC"),
                       Constructor: Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy"),
                       grid: "1", laps: "54", status: "Finished"),
                Result(number: "2", position: "2", positionText: "3", points: "442",
                       Driver: JolpyDriver(driverId: "42", url: "", givenName: "Seb Dam", familyName: "Damiens-Cerf", dateOfBirth: "1979-04-25", nationality: "France", permanentNumber: nil, code: "SDC"),
                       Constructor: Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy"),
                       grid: "1", laps: "54", status: "Finished"),
                Result(number: "3", position: "3", positionText: "3", points: "442",
                       Driver: JolpyDriver(driverId: "42", url: "", givenName: "Seb Dam", familyName: "Damiens-Cerf", dateOfBirth: "1979-04-25", nationality: "France", permanentNumber: nil, code: "SDC"),
                       Constructor: Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy"),
                       grid: "1", laps: "54", status: "Finished")
             ])),
                   meeting: .constant(Meeting(circuit_key: 14, circuit_short_name: "Mexico City", country_code: "MEX", country_key: 42, country_name: "Mexic", date_start: Date(), gmt_offset: "", location: "", meeting_key: 42, meeting_name: "Mexico GP", meeting_official_name: "Mexico GP", year: 2024)),
                   drivers: [
                    Driver(broadcast_name: "SDC", country_code: "FRA", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "https://www.formula1.com/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png.transform/1col/image.png", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari")
                   ])
}
