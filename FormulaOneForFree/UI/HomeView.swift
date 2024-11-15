//
//  HomeView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//
import SwiftUI

struct HomeView: View {
    @State var loadingData = false
    @Binding var seasons: [Season]
    @Binding var drivers: [Driver]
    @Binding var jolpyDrivers: [JolpyDriver]
    @Binding var constructors: [Constructor]
    @State var preferences: Preferences = .init(driverId: "0", constructorId: "0")
    
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
                    RaceHView(seasons: $seasons, drivers: $drivers)
                }
                Tab("Championship", systemImage: "flag.pattern.checkered.2.crossed") {
                    ChampionshipView(seasons: seasons, drivers: drivers)
                }
                Tab("Preferences", systemImage: "star") {
                    PreferencesView(drivers: jolpyDrivers,
                                    constructors: constructors,
                                    selectedDriver: $jolpyDrivers.wrappedValue.first(where: {$0.driverId == preferences.driverId}),
                                    selectedConstructor: $constructors.wrappedValue.first(where: {$0.constructorId == preferences.constructorId}))
                }
            }
            .onChange(of: drivers, initial: true) {
                LoadDataIfPossible()
            }
            .onChange(of: constructors, initial: true) {
                LoadDataIfPossible()
            }
        }
    }
    
    private func LoadDataIfPossible() {
        if($jolpyDrivers.wrappedValue.count > 0 && $constructors.wrappedValue.count > 0){
            Task { @MainActor in
                await LoadData()
            }
        }
    }
    private func LoadData() async {
        loadingData = true
        
        let prefRepo = PreferencesRepository()
        var preferences = prefRepo.readPreferences()
        
        if($jolpyDrivers.wrappedValue.first(where: {$0.driverId == preferences.driverId}) == nil){
            preferences.driverId = self.$jolpyDrivers.wrappedValue.first!.driverId
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
    
    let jolpyDrivers = [
        JolpyDriver(driverId: "max_verstappen", url: "", givenName: "Max", familyName: "Verstappen", dateOfBirth: "2024-01-01", nationality: "Dutch", permanentNumber: "33", code: "VER"),
        JolpyDriver(driverId: "max_verstappen", url: "", givenName: "Max", familyName: "Verstappen", dateOfBirth: "2024-01-01", nationality: "Dutch", permanentNumber: "33", code: "VER"),
        JolpyDriver(driverId: "max_verstappen", url: "", givenName: "Max", familyName: "Verstappen", dateOfBirth: "2024-01-01", nationality: "Dutch", permanentNumber: "33", code: "VER")
    ]
    
    let constructors = [
        Constructor(constructorId: "42", url: "", name: "Redbull F1 Racing", nationality: "AUS"),
        Constructor(constructorId: "24", url: "", name: "Alpine F1 Racing", nationality: "FR")
    ]
    
    
    HomeView(seasons: .constant([Season(season: "2024", url: "")]),
             drivers: .constant(drivers),
             jolpyDrivers: .constant(jolpyDrivers),
             constructors: .constant(constructors),
             preferences: .init(driverId: "42", constructorId: "42"))
}
