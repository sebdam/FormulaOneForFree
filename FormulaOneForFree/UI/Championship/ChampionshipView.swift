//
//  ChampionshipView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//
import SwiftUI

struct ChampionshipView: View {
    @State var seasons: [Season]
    @State var drivers: [Driver] = []
    var body: some View {
        NavigationStack {
            List($seasons) { season in
                NavigationLink {
                    SeasonView(season: season.wrappedValue,
                               driversStandings: [],
                               constructorsStandings: [],
                               drivers: drivers)
                } label: {
                    SeasonItemView(season: season)
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
    
}

#Preview() {
    ChampionshipView(seasons: [
        Season(season: "2023", url: ""),
        Season(season: "2024", url: ""),
        Season(season: "2025", url: "")], drivers: [])
}
