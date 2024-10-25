//
//  RaceDetailView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 24/10/2024.
//

import SwiftUI

struct RaceDetailView: View {
    @Binding var race: Race
    @Binding var meeting: Meeting?
    @State var drivers: [Driver] = []
    
    @State var loading = false
    
    var body: some View {
        if(loading){
            VStack {
                ProgressView()
                Text("Loading data ...")
            }
        }
        else {
            VStack {
                Text($race.wrappedValue.season)
                    .frame(maxWidth:.infinity)
                    .clipShape(.rect(cornerRadius: 12))
                Text($race.wrappedValue.raceName)
                    .font(.title2)
                    .frame(maxWidth:.infinity)
                
                AsyncImage(url: URL(string: FormulaOneRepository.GetCircuitImageUrl($race.wrappedValue.Circuit))) { phase in
                    switch phase {
                        case .empty: ProgressView()
                        case .success(let image): image.resizable()
                        case .failure(_): EmptyView()
                        @unknown default: EmptyView()
                    }
                }
                .frame(width: UIScreen.main.bounds.width-70, height: 716*(UIScreen.main.bounds.width-70)/1272)
                
                if($race.wrappedValue.FirstPractice != nil){
                    let session = meeting?.sessions?.first(where: {$0.session_name == "Practice 1"})
                    if(session != nil){
                        NavigationLink() {
                            SessionResultsView(session: session!, drivers: drivers, results: [])
                        } label: {
                            ScheduleView(dueDate: .constant($race.wrappedValue.FirstPractice?.datetime), scheduleName: "Practice 1")
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
                            ScheduleView(dueDate: .constant($race.wrappedValue.SecondPractice?.datetime), scheduleName: "Practice 2")
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
                            ScheduleView(dueDate: .constant($race.wrappedValue.ThirdPractice?.datetime), scheduleName: "Practice 3")
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
                            SessionResultsView(session: session!, drivers: drivers, results: [])
                        } label: {
                            ScheduleView(dueDate: .constant($race.wrappedValue.SprintQualifying?.datetime), scheduleName: "Sprint Qualifying")
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
                            ScheduleView(dueDate: .constant($race.wrappedValue.Sprint?.datetime), scheduleName: "Sprint")
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
                    let session = meeting?.sessions?.first(where: {$0.session_name == "Qualifying"})
                    if(session != nil){
                        NavigationLink() {
                            SessionResultsView(session: session!, drivers: drivers, results: [])
                        } label: {
                            ScheduleView(dueDate: .constant($race.wrappedValue.Qualifying?.datetime), scheduleName: "Qualifying")
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
                        ScheduleView(dueDate:Binding<Date?>.constant($race.wrappedValue.datetime), scheduleName: "Race")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                else {
                    ScheduleView(dueDate:Binding<Date?>.constant($race.wrappedValue.datetime), scheduleName: "Race")
                        .frame(maxWidth: .infinity)
                }

                
                if($race.wrappedValue.Results?.count ?? 0 >= 3) {
                    HStack {
                        VStack {
                            let result = $race.wrappedValue.Results?.first(where: {$0.position == "2"})
                            let driver = $drivers.wrappedValue.first(where: {$0.name_acronym == result?.Driver.code})
                            let driverUrl = driver?.headshot_url
                            let team = driver?.team_name
                            
                            Spacer()
                            
                            if(driverUrl != nil) {
                                AsyncImage(url: URL(string: driverUrl!)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(.rect(cornerRadius: 12))
                            }
                            else {
                                Image("helmetWithDriver")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(.rect(cornerRadius: 12))
                            }
                            Spacer().frame(height: 20)
                            Text(result?.Driver.code ?? result?.Driver.givenName ?? "John Doe")
                            if(team != nil){
                                AsyncImage(url: URL(string: "https://media.formula1.com/d_team_car_fallback_image.png/content/dam/fom-website/teams/2024/\(team!.replacingOccurrences(of: " ", with: "-")).png")) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 87, height: 25)
                                .clipShape(.rect(cornerRadius: 12))
                                
                                Text("\(team!)").font(.caption2)
                            }
                            Text("2")
                        }
                        .frame(maxWidth:.infinity)
                        
                        VStack {
                            let result = $race.wrappedValue.Results?.first(where: {$0.position == "1"})
                            let driver = $drivers.wrappedValue.first(where: {$0.name_acronym == result?.Driver.code})
                            let driverUrl = driver?.headshot_url
                            let team = driver?.team_name
                            
                            Spacer()
                            
                            if(driverUrl != nil) {
                                AsyncImage(url: URL(string: driverUrl!)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(.rect(cornerRadius: 12))
                            }
                            else {
                                Image("helmetWithDriver")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(.rect(cornerRadius: 12))
                            }
                            Spacer().frame(height: 40)
                            Text(result?.Driver.code ?? result?.Driver.givenName ?? "John Doe")
                            if(team != nil){
                                AsyncImage(url: URL(string: "https://media.formula1.com/d_team_car_fallback_image.png/content/dam/fom-website/teams/2024/\(team!.replacingOccurrences(of: " ", with: "-")).png")) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 87, height: 25)
                                .clipShape(.rect(cornerRadius: 12))
                                
                                Text("\(team!)").font(.caption2)
                            }
                            Text("1")
                        }
                        .frame(maxWidth:.infinity)
                        
                        VStack {
                            let result = $race.wrappedValue.Results?.first(where: {$0.position == "3"})
                            let driver = $drivers.wrappedValue.first(where: {$0.name_acronym == result?.Driver.code})
                            let driverUrl = driver?.headshot_url
                            let team = driver?.team_name
                            
                            Spacer()
                            
                            if(driverUrl != nil) {
                                AsyncImage(url: URL(string: driverUrl!)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(.rect(cornerRadius: 12))
                            }
                            else {
                                Image("helmetWithDriver")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(.rect(cornerRadius: 12))
                            }
                            
                            Text(result?.Driver.code ?? result?.Driver.givenName ?? "John Doe")
                            if(team != nil){
                                AsyncImage(url: URL(string: "https://media.formula1.com/d_team_car_fallback_image.png/content/dam/fom-website/teams/2024/\(team!.replacingOccurrences(of: " ", with: "-")).png")) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 87, height: 25)
                                .clipShape(.rect(cornerRadius: 12))
                                
                                Text("\(team!)").font(.caption2)
                            }
                            Text("3")
                        }
                        .frame(maxWidth:.infinity)
                    }
                    .frame(alignment: .bottom)
                }
                
                Spacer()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width-70)
            .cornerRadius(12)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.blue, lineWidth: 2)
            )
        }
    }
    
}

#Preview {
    RaceDetailView(race: .constant(Race(season: "2024", round: "1", url: "", raceName: "Champion 1",
                                        Circuit: Circuit(circuitId: "42", url: "", circuitName: "Hockenheimring", Location: Location(lat: "", long: "", locality: "", country: "")),
                                        date: "2024-01-01T00:00:00.000+00:00", time: nil,
                                        FirstPractice: Schedule(date: "", time: nil),
                                        SecondPractice: Schedule(date: "", time: nil),
                                        ThirdPractice: Schedule(date: "", time: nil),
                                        SprintQualifying: Schedule(date: "", time: nil),
                                        Sprint: Schedule(date: "", time: nil),
                                        Qualifying: Schedule(date: "", time: nil))),
                   meeting: .constant(nil))
}
