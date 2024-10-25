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
                /*
                Tab("Races", systemImage: "car.2") {
                    RaceView(seasons: seasons, drivers: drivers)
                }
                */
                Tab("Races", systemImage: "car.2") {
                    RaceHView(seasons: seasons, drivers: drivers)
                }
                Tab("Championship", systemImage: "flag.pattern.checkered.2.crossed") {
                    ChampionshipView(seasons: seasons, drivers: drivers)
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
        
        loadingData = false
    }
    
}

#Preview() {
    HomeView(seasons: [Season(season: "2024", url: "")], drivers: [])
}
