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
    
    @State var seasons: [Season]
    @State var drivers: [Driver] = []
    
    @State var races: [Race] = []
    @State var meetings: [Meeting] = []
    
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
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing: 30){
                                if(loadingPrev){
                                    VStack {
                                        ProgressView()
                                        Text("Loading prev season ...")
                                    }.containerRelativeFrame(.horizontal)
                                }

                                ForEach($races, id:\.id){ race in
                                    let meeting = meetings.first(where: {$0.meeting_name == race.wrappedValue.raceName && $0.year == Int(race.wrappedValue.season) })
                                    RaceDetailView(race: race, meeting: .constant(meeting), drivers: drivers)
                                        .containerRelativeFrame(.horizontal)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .frame(maxHeight: .infinity)
                        .scrollTargetBehavior(.viewAligned)
                        .onChange(of: mustScroll, initial: true) { oldValue, newValue  in
                            //print("changed mustScroll")
                            //print("\(oldValue) -> \(newValue)")
                            if(mustScroll){
                                //print("ScrollId :\(scrollId)")
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
                            
                            //print("\(oldId!) -> \(id!)")
                            
                            let index = $races.wrappedValue.firstIndex(where: {$0.id == id})
                            if(index == 0 && !loadingPrev){
                                let prevSeason = Int($races.wrappedValue[0].season)! - 1
                                if($seasons.wrappedValue.firstIndex(where: {$0.season == String(prevSeason)}) != nil) {
                                    Task { @MainActor in
                                        loadingPrev = true
                                        firstSet = false
                                        await Load(currentYear: prevSeason)
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
                await Load(currentYear: currentYear)
            }
        }
        
        
    }
    
    private func Load(currentYear: Int) async {
        if(loading || firstSet){
            return
        }
        
        if(!loadingPrev){
            loading = true
        }
        
        let jolpyRepo = JolpyF1Repository()
        
        let data = await jolpyRepo.GetMeetings(forYear: currentYear)
        $races.wrappedValue.insert(contentsOf: data?.MRData.RaceTable?.Races ?? [], at: 0)
        
        if(currentYear>=2023) {
            let openF1Repo = OpenF1Repository()
            let meetings = await openF1Repo.LoadMeetingsData(forYear: currentYear)
            self.$meetings.wrappedValue.insert(contentsOf: meetings ?? [], at: 0)
        }
        
        firstSet = true
        loading = false
        mustScroll = true
        loadingPrev = false
    }
    
    private func SelectRace(round: Int? = nil) -> Race? {
        $races.wrappedValue.sort(by: {$0.datetime! < $1.datetime!})
        let race = $races.wrappedValue.first(where: {Calendar.current.date(byAdding: .init(day: 1), to: $0.datetime!)! > Date()})
        return race ?? $races.wrappedValue.last
    }
}

#Preview {
    RaceHView(seasons: [Season(season: "2023", url: ""),Season(season: "2024", url: "")],
              races: [Race(season: "2024", round: "1", url: "", raceName: "Champion 1",
                           Circuit: Circuit(circuitId: "42", url: "", circuitName: "SPA", Location: Location(lat: "", long: "", locality: "", country: "")),
                           date: "2024-01-01T00:00:00.000+00:00", time: nil,
                           FirstPractice: Schedule(date: "", time: nil),
                           SecondPractice: Schedule(date: "", time: nil),
                           ThirdPractice: Schedule(date: "", time: nil),
                           SprintQualifying: Schedule(date: "", time: nil),
                           Sprint: Schedule(date: "", time: nil),
                           Qualifying: Schedule(date: "", time: nil)),
                      Race(season: "2024", round: "2", url: "", raceName: "Champion 2",
                           Circuit: Circuit(circuitId: "42", url: "", circuitName: "SPA", Location: Location(lat: "", long: "", locality: "", country: "")),
                           date: "2024-01-01T00:00:00.000+00:00", time: nil,
                           FirstPractice: Schedule(date: "", time: nil),
                           SecondPractice: Schedule(date: "", time: nil),
                           ThirdPractice: Schedule(date: "", time: nil),
                           SprintQualifying: Schedule(date: "", time: nil),
                           Sprint: Schedule(date: "", time: nil),
                           Qualifying: Schedule(date: "", time: nil)),
                      Race(season: "2024", round: "3", url: "", raceName: "Champion 3",
                           Circuit: Circuit(circuitId: "42", url: "", circuitName: "SPA", Location: Location(lat: "", long: "", locality: "", country: "")),
                           date: "2024-01-01T00:00:00.000+00:00", time: nil,
                           FirstPractice: Schedule(date: "", time: nil),
                           SecondPractice: Schedule(date: "", time: nil),
                           ThirdPractice: Schedule(date: "", time: nil),
                           SprintQualifying: Schedule(date: "", time: nil),
                           Sprint: Schedule(date: "", time: nil),
                           Qualifying: Schedule(date: "", time: nil))])
}
