//
//  RaceHView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 24/10/2024.
//

import SwiftUI

struct RaceHView: View {
    @State var loading = false;
    @State var loadingPrev = false;
    @State var firstSet = false;
    @State var mustScroll = false
    
    @Binding var seasons: [Season]
    @Binding var drivers: [Driver]
    
    @StateObject private var store = DataStore()
    
    @State var scrollId: UUID?
    
    
    var body: some View {
        NavigationStack {
            if(loading) {
                VStack {
                    ProgressView()
                    Text("Loading data ...")
                }
            }
            else {
                VStack {
                    HStack {
                        
                        Spacer()
                        
                        Button(
                            action: {
                                let race = SelectRace()
                                if(race != nil){
                                    scrollId = race!.id
                                    mustScroll = true
                                }
                            }, label: {
                                Image(systemName: "forward.end")
                            })
                        .padding([.trailing, .bottom], 3)
                    }
                    
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false){
                            LazyHStack(spacing: 30){
                                if(loadingPrev){
                                    VStack {
                                        ProgressView()
                                        Text("Loading prev season ...")
                                    }.containerRelativeFrame(.horizontal)
                                }

                                ForEach($store.Races, id:\.id){ race in
                                    let meeting = store.Meetings.first(where: {$0.meeting_name == race.wrappedValue.raceName && $0.year == Int(race.wrappedValue.season) })
                                    
                                    RaceDetailView(race: race, meeting: .constant(meeting), drivers: drivers)
                                        .containerRelativeFrame(.horizontal)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .frame(maxHeight: .infinity)
                        .scrollTargetBehavior(.viewAligned)
                        .onChange(of: mustScroll, initial: true) { oldValue, newValue  in
                            if(mustScroll){
                                if(scrollId != nil){
                                    proxy.scrollTo(scrollId!, anchor: .trailing)
                                }
                                else {
                                    let race = SelectRace()
                                    if(race != nil){
                                        withAnimation(.easeInOut(duration: 10)) {
                                            proxy.scrollTo(race!.id, anchor: .trailing)
                                        }
                                    }
                                }
                                mustScroll = false
                            }
                        }
                        .scrollPosition(id: $scrollId)
                        .onChange(of: scrollId) { oldId, id in
                            if(id==nil || oldId==nil || oldId == id){
                                return
                            }
                            
                            let index = $store.Races.wrappedValue.firstIndex(where: {$0.id == id})
                            if(index == 0 && !loadingPrev){
                                let prevSeason = Int($store.Races.wrappedValue[0].season)! - 1
                                if($seasons.wrappedValue.firstIndex(where: {$0.season == String(prevSeason)}) != nil) {
                                    Task { @MainActor in
                                        await Load(forYear: prevSeason)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }.onAppear(){
            Task { @MainActor in
                let currentYear = Calendar.current.component(.year, from: Date())
                await Load(forYear: currentYear)
            }
        }
        
        
    }
    
    private func Load(forYear: Int) async {
        
        if(loading || loadingPrev){
            return
        }
        
        let currentYear = Calendar.current.component(.year, from: Date())
        if(currentYear > forYear){
            loadingPrev = true
            firstSet = false
        }
        
        if(firstSet){
            return
        }
        
        if(!loadingPrev){
            loading = true
        }
        
        do {
            try await store.loadRaces(year: forYear)
            
        } catch {
            fatalError(error.localizedDescription)
        }
        
        firstSet = true
        loading = false
        mustScroll = true
        loadingPrev = false
    }
    
    private func SelectRace(round: Int? = nil) -> Race? {
        $store.Races.wrappedValue.sort(by: {$0.datetime! < $1.datetime!})
        let race = $store.Races.wrappedValue.first(where: {Calendar.current.date(byAdding: .init(day: 1), to: $0.datetime!)! > Date()})
        return race ?? $store.Races.wrappedValue.last
    }
}

#Preview {
    RaceHView(seasons: .constant([Season(season: "2023", url: ""),Season(season: "2024", url: "")]), drivers: .constant([]))
}
