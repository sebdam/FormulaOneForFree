//
//  ContentView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 19/10/2024.
//

import SwiftUI

struct RaceView: View {
    
    @State var loadingData = false;
    @State var loadingMeeting = false;
    @State var firstSet = false;
    
    @State var seasons: [Season]
    @State var races: [Race] = []
    @State var meetings: [Meeting] = []
    
    @State var race: Race?
    @State var meeting: Meeting?
    @State var circuitImage: UIImage?
    
    @State var ShowFuturPractice1 = true
    @State var ShowFuturPractice2 = true
    @State var ShowFuturPractice3 = true
    @State var ShowFuturSprintQualifying = true
    @State var ShowFuturSprint = true
    @State var ShowFuturQualifying = true
    @State var ShowFuturRace = true
    
    @State var drivers:[Driver] = []
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if(loadingData){
                VStack {
                    ProgressView()
                    Text("Loading data ...")
                }
            }
            else {
                NavigationSplitView {
                    if(loadingMeeting){
                        VStack {
                            ProgressView()
                            Text("Loading meeting ...")
                        }
                    }
                    else {
                        ZStack {
                            VStack {
                                HStack{
                                    Button() {
                                        PrevRace()
                                    } label: {
                                        Text("Prev")
                                    }
                                    
                                    VStack {
                                        Text(race?.season ?? "")
                                            .frame(maxWidth:.infinity)
                                        Text(race?.raceName ?? "")
                                            .font(.title2)
                                            .frame(maxWidth:.infinity)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    Button() {
                                        NextRace()
                                    } label: {
                                        Text("Next")
                                    }
                                }
                                
                                if(circuitImage != nil){
                                    Image(uiImage: circuitImage!)
                                        .resizable()
                                        .frame(height:250)
                                }
                                
                                Spacer()
                                
                                //Manage past events
                                if(meeting?.sessions != nil){
                                    ForEach(meeting!.sessions!){ session in
                                        let raceResults = session.session_name == "Sprint" || session.session_name == "Race" ? race?.Results : nil
                                        NavigationLink() {
                                            SessionResultsView(session: session, drivers: drivers, results: raceResults ?? [])
                                        } label: {
                                            ScheduleView(dueDate:Binding<Date?>.constant(session.date_start), scheduleName: session.session_name)
                                                .frame(maxWidth: .infinity)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                
                                //Manage futur events
                                if(ShowFuturPractice1){
                                    ScheduleView(dueDate:Binding<Date?>.constant($race.wrappedValue?.FirstPractice?.datetime), scheduleName: "Practice 1")
                                        .frame(maxWidth: .infinity)
                                }
                                if(ShowFuturPractice2){
                                    ScheduleView(dueDate:Binding<Date?>.constant($race.wrappedValue?.SecondPractice?.datetime), scheduleName: "Practice 2")
                                        .frame(maxWidth: .infinity)
                                }
                                if(ShowFuturPractice3){
                                    ScheduleView(dueDate:Binding<Date?>.constant($race.wrappedValue?.ThirdPractice?.datetime), scheduleName: "Practice 3")
                                        .frame(maxWidth: .infinity)
                                }
                                if(ShowFuturSprintQualifying){
                                    ScheduleView(dueDate:Binding<Date?>.constant($race.wrappedValue?.SprintQualifying?.datetime), scheduleName: "Sprint Qualifying")
                                        .frame(maxWidth: .infinity)
                                }
                                if(ShowFuturSprint){
                                    ScheduleView(dueDate:Binding<Date?>.constant($race.wrappedValue?.Sprint?.datetime), scheduleName: "Sprint")
                                        .frame(maxWidth: .infinity)
                                }
                                if(ShowFuturQualifying){
                                    ScheduleView(dueDate:Binding<Date?>.constant($race.wrappedValue?.Qualifying?.datetime), scheduleName: "Qualifying")
                                        .frame(maxWidth: .infinity)
                                }
                                if(ShowFuturRace){
                                    ScheduleView(dueDate:Binding<Date?>.constant($race.wrappedValue?.datetime), scheduleName: "Race")
                                        .frame(maxWidth: .infinity)
                                }
                                
                                Spacer()
                                
                                if(race?.Results != nil) {
                                    HStack {
                                        VStack {
                                            let result = race!.Results!.first(where: {$0.position == "2"})!
                                            let driver = $drivers.wrappedValue.first(where: {$0.name_acronym == result.Driver.code})
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
                                            Text(result.Driver.code ?? result.Driver.givenName)
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
                                            let result = race!.Results!.first(where: {$0.position == "1"})!
                                            let driver = $drivers.wrappedValue.first(where: {$0.name_acronym == result.Driver.code})
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
                                            Text(result.Driver.code ?? result.Driver.givenName)
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
                                            let result = race!.Results!.first(where: {$0.position == "3"})!
                                            let driver = $drivers.wrappedValue.first(where: {$0.name_acronym == result.Driver.code})
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
                                            
                                            Text(result.Driver.code ?? result.Driver.givenName)
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
                        }
                        .onReceive(timer) { _ in
                            computeFurturVisibleIndicators()
                        }
                    }
                    
                } detail: {
                    Text("Results")
                }
            }
        }
        .padding()
        .onAppear() {
            Task { @MainActor in
                let currentYear = Calendar.current.component(.year, from: Date())
                await Load(currentYear: currentYear)
            }
        }
        .onChange(of: race) {
            Task { @MainActor in
                await LoadCurrentRaceData()
            }
        }
    }
    
    private func computeFurturVisibleIndicators() {
        let now = Date()
        
        if(race != nil){
            ShowFuturPractice1 = race!.FirstPractice?.datetime ?? now > now
            ShowFuturPractice2 = race!.SecondPractice?.datetime ?? now > now
            ShowFuturPractice3 = race!.ThirdPractice?.datetime ?? now > now
            ShowFuturSprintQualifying = race!.SprintQualifying?.datetime ?? now > now
            ShowFuturSprint = race!.Sprint?.datetime ?? now > now
            ShowFuturQualifying = race!.Qualifying?.datetime ?? now > now
            ShowFuturRace = try! race!.datetime ?? now > now || race!.datetime ?? now < Date("2023-01-01T00:00:00.000+00:00", strategy: .iso8601withFractionalSeconds)
        }
    }
    
    private func PrevRace() {
        Task { @MainActor in
            let currentRound = Int($race.wrappedValue?.round ?? "0")!
            if(currentRound > 1){
                _ = await SelectRace(round: currentRound-1)
            }
            else {
                let minSeason = seasons.min(by: {Int($0.season)! < Int($1.season)!})
                if(minSeason != nil && $race.wrappedValue != nil && Int(minSeason!.season)! < Int($race.wrappedValue!.season)!){
                    let currentYear = Int($race.wrappedValue!.season)!
                    firstSet = false
                    await Load(currentYear: currentYear-1)
                }
            }
        }
    }
    
    private func NextRace() {
        Task { @MainActor in
            let currentRound = Int($race.wrappedValue?.round ?? "0")!
            let maxRound = Int($races.wrappedValue.sorted(by: {Int($0.round)! < Int($1.round)!}).last?.round ?? "0")!
            if(currentRound < maxRound){
                _ = await SelectRace(round: currentRound+1)
            }
            else {
                let maxSeason = seasons.max(by: {Int($0.season)! < Int($1.season)!})
                if(maxSeason != nil && $race.wrappedValue != nil && Int(maxSeason!.season)! > Int($race.wrappedValue!.season)!){
                    let currentYear = Int($race.wrappedValue!.season)!
                    firstSet = false
                    await Load(currentYear: currentYear+1)
                }
                
            }
        }
    }
    
    private func Load(currentYear: Int) async {
        if(loadingData || loadingMeeting || firstSet){
            return
        }
        
        loadingData = true
        let jolpyRepo = JolpyF1Repository()
        
        let data = await jolpyRepo.GetMeetings(forYear: currentYear)
        $races.wrappedValue = data?.MRData.RaceTable?.Races ?? []
        
        if(currentYear>2023) {
            let openF1Repo = OpenF1Repository()
            let meetings = await openF1Repo.LoadMeetingsData(forYear: currentYear)
            self.$meetings.wrappedValue = meetings ?? []
        }
        else {
            self.$meetings.wrappedValue = []
        }
        
        _ = await SelectRace()
        
        firstSet = true
        loadingData = false
    }
    
    private func SelectRace(round: Int? = nil) async -> Race? {
        loadingMeeting = true
        
        $meeting.wrappedValue = nil
        $race.wrappedValue = nil
        $circuitImage.wrappedValue = nil
        
        if($races.wrappedValue.count>0) {
            if(round != nil){
                let race = $races.wrappedValue.first(where: {$0.round == String(round!)})
                self.$race.wrappedValue = race
                loadingMeeting = false
                return race
            }
            
            $races.wrappedValue.sort(by: {$0.datetime! < $1.datetime!})
            let race = $races.wrappedValue.first(where: {Calendar.current.date(byAdding: .init(day: 1), to: $0.datetime!)! > Date()})
            self.$race.wrappedValue = race ?? $races.wrappedValue.last
            loadingMeeting = false
            return race
        }
        
        loadingMeeting = false
        return nil
    }
    
    private func LoadCurrentRaceData() async {
        if($race.wrappedValue != nil){
            
            let f1Repo = FormulaOneRepository()
            let image = await f1Repo.GetCircuitImage(circuit: $race.wrappedValue!.Circuit.circuitName)
            
            if(image != nil){
                self.$circuitImage.wrappedValue = image
            }
            
            let meeting = $meetings.wrappedValue.filter({$0.meeting_name == $race.wrappedValue!.raceName})
            self.$meeting.wrappedValue = meeting.first
        }
        
        computeFurturVisibleIndicators()
    }
}

#Preview {
    RaceView(seasons: [Season(season: "2023", url: ""),Season(season: "2024", url: "")])
}
