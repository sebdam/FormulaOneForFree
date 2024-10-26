//
//  HomeView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//
import SwiftUI

struct HomeView: View {
    @State var loadingData = false
    @State var seasons: [Season] = []
    @State var drivers: [Driver] = []
    @State var constructors: [Constructor] = []
    @State var preferences: Preferences = .init(driverId: 0, constructorId: "0")
    
    var body: some View {
        if(loadingData){
            VStack {
                Spacer()
                ProgressView()
                Text("Loading ...")
                Spacer()
            }
        }
        else {
            TabView {
                Tab("Races", systemImage: "car.2") {
                    RaceHView(seasons: seasons, drivers: drivers)
                }
                Tab("Championship", systemImage: "flag.pattern.checkered.2.crossed") {
                    ChampionshipView(seasons: seasons, drivers: drivers)
                }
                Tab("Preferences", systemImage: "star") {
                    PreferencesView(drivers: drivers,
                                    constructors: constructors,
                                    selectedDriver: $drivers.wrappedValue.first(where: {$0.driver_number == preferences.driverId}),
                                    selectedConstructor: $constructors.wrappedValue.first(where: {$0.constructorId == preferences.constructorId}))
                }
            }.onAppear() {
                Task { @MainActor in
                    await LoadData()
                }
            }
        }
    }
    
    private func LoadData() async {
        loadingData = true
        let jolpyRepo = JolpyF1Repository()
        
        if($seasons.wrappedValue.count<=0){
            let result = await jolpyRepo.GetSeasons()
            if(result?.MRData.SeasonTable != nil){
                self.$seasons.wrappedValue = result?.MRData.SeasonTable?.Seasons ?? []
            }
        }
        
        if(self.$drivers.wrappedValue.count<=0) {
            let openF1Repo = OpenF1Repository()
            let drivers = await openF1Repo.GetDrivers()
            self.$drivers.wrappedValue = drivers ?? []
        }
        
        if(self.$constructors.wrappedValue.count<=0) {
            let lastSeason = self.$seasons.wrappedValue.last?.seasonAsInt
            if(lastSeason != nil){
                let constructors = await jolpyRepo.GetConstructors(forYear: lastSeason!)
                self.$constructors.wrappedValue = constructors?.MRData.ConstructorTable?.Constructors ?? []
            }
        }
        
        let prefRepo = PreferencesRepository()
        var preferences = prefRepo.readPreferences()
        
        if($drivers.wrappedValue.first(where: {$0.driver_number == preferences.driverId}) == nil){
            preferences.driverId = self.$drivers.wrappedValue.first!.driver_number
        }
        if($constructors.wrappedValue.first(where: {$0.constructorId == preferences.constructorId}) == nil){
            preferences.constructorId = self.$constructors.wrappedValue.first!.constructorId
        }
        prefRepo.savePreferences(preferences: preferences)
        self.$preferences.wrappedValue = preferences
        
        loadingData = false
    }
    
}

#Preview() {
    let drivers = [
        Driver(broadcast_name: "SDC", country_code: "FRA", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"),
        Driver(broadcast_name: "POLO", country_code: "BEL", driver_number: 43, first_name: "Paul", full_name: "Paul Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "POLO", session_key: 42, team_colour: nil, team_name: "Ferrari"),
        Driver(broadcast_name: "MALO", country_code: "GB", driver_number: 44, first_name: "Malo", full_name: "Malo Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "MALO", session_key: 42, team_colour: nil, team_name: "Ferrari")
    ]
    
    
    let constructors = [
        Constructor(constructorId: "42", url: "", name: "Redbull F1 Racing", nationality: "AUS"),
        Constructor(constructorId: "24", url: "", name: "Alpine F1 Racing", nationality: "FR")
    ]
    
    
    HomeView(seasons: [Season(season: "2024", url: "")],
             drivers: drivers,
             constructors: constructors,
             preferences: .init(driverId: 42, constructorId: "42"))
}
