//
//  PreferencesView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 26/10/2024.
//

import SwiftUI

struct PreferencesView: View {
    @State var drivers: [Driver] = []
    @State var constructors: [Constructor] = []
    
    @State var selectedDriver: Driver?
    @State var selectedConstructor: Constructor?
    
    var body: some View {
        VStack {
            List {
                
                Section(header: Text("Favorite driver")) {
                    VStack {
                        Picker(selection: $selectedDriver) {
                            ForEach(drivers, id: \.id) { driver in
                                Text(driver.full_name).tag(driver as Driver?)
                            }
                        } label: {
                            Text("Driver")
                        }.frame(maxWidth: .infinity)
                        
                        let selectedDriver = $selectedDriver.wrappedValue
                        HStack {
                            Text(selectedDriver?.country_code ?? "")
                                .frame(maxWidth: .infinity)
                            Spacer()
                            Text(selectedDriver?.name_acronym ?? "")
                                .frame(maxWidth: .infinity)
                            Spacer()
                            Text(selectedDriver?.team_name ?? "")
                                .frame(maxWidth: .infinity)
                        }
                        
                        Text("Choose your favorite driver, and you'll see him in the 'Stared driver widget'")
                            .multilineTextAlignment(.center)
                            .font(.footnote)
                            .frame(maxWidth: .infinity)
                    }
                    
                }
                
                Section(header: Text("Favorite constructor")) {
                    VStack {
                        Picker(selection: $selectedConstructor) {
                            ForEach(constructors, id: \.id) { constructor in
                                Text(constructor.name).tag(constructor as Constructor?)
                            }
                        } label: {
                            Text("Constructor")
                        }.frame(maxWidth: .infinity)
                        
                        let selectedConstructor = $selectedConstructor.wrappedValue
                        HStack {
                            Text(selectedConstructor?.nationality ?? "")
                                .frame(maxWidth: .infinity)
                        }
                        
                        Text("Choose your favorite constructor, and you'll see him in the 'Stared constructor widget'")
                            .multilineTextAlignment(.center)
                            .font(.footnote)
                            .frame(maxWidth: .infinity)
                    }
                    
                }
                
            }
        }.onChange(of: selectedDriver) {
            Task { @MainActor in
                await SavePreferences()
            }
        }.onChange(of: selectedConstructor) {
            Task { @MainActor in
                await SavePreferences()
            }
        }
    }
    
    private func SavePreferences() async {
        let repo = PreferencesRepository()
        let pref = Preferences(driverId: selectedDriver!.driver_number, constructorId: selectedConstructor!.constructorId)
        repo.savePreferences(preferences: pref)
    }
}

#Preview {
    let drivers = [
        Driver(broadcast_name: "SDC", country_code: "FRA", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"),
        Driver(broadcast_name: "POLO", country_code: "BEL", driver_number: 43, first_name: "Paul", full_name: "Paul Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "POLO", session_key: 42, team_colour: nil, team_name: "Ferrari"),
        Driver(broadcast_name: "MALO", country_code: "GB", driver_number: 44, first_name: "Malo", full_name: "Malo Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "MALO", session_key: 42, team_colour: nil, team_name: "Ferrari")
    ]
    
    let constructors = [
        Constructor(constructorId: "42", url: "", name: "Redbull F1 Racing", nationality: "AUS"),
        Constructor(constructorId: "24", url: "", name: "Alpine F1 Racing", nationality: "FR")
    ]
    
    PreferencesView(drivers: drivers,
                    constructors: constructors,
                    selectedDriver: drivers.first!,
                    selectedConstructor: constructors.first!)
}
