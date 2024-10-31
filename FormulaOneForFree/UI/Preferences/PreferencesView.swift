//
//  PreferencesView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 26/10/2024.
//

import SwiftUI

struct PreferencesView: View {
    @State var drivers: [JolpyDriver] = []
    @State var constructors: [Constructor] = []
    
    @State var selectedDriver: JolpyDriver?
    @State var selectedConstructor: Constructor?
    
    var body: some View {
        VStack {
            List {
                
                Section(header: Text("Favorite driver")) {
                    VStack {
                        Picker(selection: $selectedDriver) {
                            ForEach(drivers, id: \.id) { driver in
                                Text("\(driver.givenName) \(driver.familyName)").tag(driver as JolpyDriver?)
                            }
                        } label: {
                            Text("Driver")
                        }.frame(maxWidth: .infinity)
                        
                        let selectedDriver = $selectedDriver.wrappedValue
                        HStack {
                            Text(selectedDriver?.nationality ?? "")
                                .frame(maxWidth: .infinity)
                            Spacer()
                            Text(selectedDriver?.code ?? "")
                                .frame(maxWidth: .infinity)
                            Spacer()
                            Text(selectedDriver?.dateOfBirth ?? "")
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
                        
                        Text("Choose your favorite constructor, and you'll see it in the 'Stared constructor widget'")
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
        let pref = Preferences(driverId: selectedDriver!.driverId, constructorId: selectedConstructor!.constructorId)
        repo.savePreferences(preferences: pref)
    }
}

#Preview {
    let drivers = [
        JolpyDriver(driverId: "max_verstappen", url: "", givenName: "Max", familyName: "Verstappen", dateOfBirth: "2024-01-01", nationality: "Dutch", permanentNumber: "33", code: "VER"),
        JolpyDriver(driverId: "max_verstappen", url: "", givenName: "Max", familyName: "Verstappen", dateOfBirth: "2024-01-01", nationality: "Dutch", permanentNumber: "33", code: "VER"),
        JolpyDriver(driverId: "max_verstappen", url: "", givenName: "Max", familyName: "Verstappen", dateOfBirth: "2024-01-01", nationality: "Dutch", permanentNumber: "33", code: "VER")
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
