//
//  SeasonView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import SwiftUI

struct SeasonView: View {
    @State var constructor: Bool = false
    @State private var type="Constructors"
    var types=["Constructors","Drivers"]
    
    @State var loading: Bool = false
    @State var season:Season
    @State var driversStandings: [DriverStanding]
    @State var constructorsStandings: [ConstructorStanding]
    @State var drivers: [Driver] = []
    
    var body: some View {
        NavigationStack {
            if(loading){
                VStack {
                    Spacer()
                    ProgressView()
                    Text("Loading ...")
                    Spacer()
                }
            }
            else {
                Picker("Choose the standings type", selection: $type){
                    ForEach(types, id:\.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .disabled(loading)
                
                if(type=="Drivers"){
                    if($driversStandings.wrappedValue.count<=0){
                        Spacer()
                        Text("No data ...")
                        Spacer()
                    }
                    else {
                        List($driversStandings) {
                            let standing = $0.wrappedValue
                            let openDriver = $drivers.wrappedValue.first(where: {$0.name_acronym == standing.Driver.code})
                            
                            DriverStandingView(driverStanding: $0, driver: .constant(openDriver))
                        }
                    }
                }
                else {
                    if($constructorsStandings.wrappedValue.count<=0){
                        Spacer()
                        Text("No data ...")
                        Spacer()
                    }
                    else {
                        List($constructorsStandings) { constructor in
                            ConstructorStandingView(constructorStanding: constructor)
                        }
                    }
                }
            }
        }
        .navigationTitle(season.season)
        .onAppear() {
            Task { @MainActor in
                await LoadData()
            }
        }
    }
    
    private func LoadData() async {
        if(loading){
            return
        }
        
        loading = true
        let jolpyRepo = JolpyF1Repository()
        
        var result = await jolpyRepo.GetDriverStandings(forYear: Int(season.season)!)
        if(result?.MRData.StandingsTable?.StandingsLists != nil){
            self.$driversStandings.wrappedValue = result?.MRData.StandingsTable?.StandingsLists.first?.DriverStandings ?? []
        }
    
        result = await jolpyRepo.GetConstructorStandings(forYear: Int(season.season)!)
        if(result?.MRData.StandingsTable?.StandingsLists != nil){
            self.$constructorsStandings.wrappedValue = result?.MRData.StandingsTable?.StandingsLists.first?.ConstructorStandings ?? []
        }
        
        loading = false
    }
}

#Preview {
    SeasonView(
        season: Season(season: "2024", url: ""),
               driversStandings: [DriverStanding(position: "2", positionText: "2", points: "42", wins: "12", Driver: JolpyDriver(driverId: "42", url: "", givenName: "Seb Dam", familyName: "Damiens-Cerf", dateOfBirth: "1979-04-25", nationality: "France", permanentNumber: nil, code: "SDC"), Constructors: [Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")])],
               constructorsStandings: [ConstructorStanding(position: "42", positionText: "42", points: "12", wins: "6", Constructor: Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy"))],
               drivers:[])
}
