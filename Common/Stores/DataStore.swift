//
//  DataStore.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 14/11/2024.
//

import SwiftUI

class DataStore: ObservableObject {
    @Published var Seasons: [Season] = []
    @Published var Drivers: [Driver] = []
    @Published var JolpyDrivers: [JolpyDriver] = []
    @Published var Constructors: [Constructor] = []

    @Published var Races: [Race] = []
    @Published var Meetings: [Meeting] = []

    private static func fileURL(dataStore: String) throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("\(dataStore).data")
    }

    func load() async throws {
        let seasons = try await loadFromCacheOrGetFromRepo(
            repoLoadingFunction: {
                let jolpyRepo = JolpyF1Repository()
                let data = await jolpyRepo.GetSeasons()
                return data?.MRData.SeasonTable?.Seasons ?? []
            },
            isEnoughCachedFunction: { $0.count > 0 })

        let drivers = try await loadFromCacheOrGetFromRepo(
            repoLoadingFunction: {
                let openF1Repo = OpenF1Repository()
                let drivers = await openF1Repo.GetDrivers()
                return drivers ?? []
            },
            isEnoughCachedFunction: { $0.count > 0 })

        let jolpyDrivers = try await loadFromCacheOrGetFromRepo(
            repoLoadingFunction: {
                let lastSeason = seasons.max(by: {
                    $0.seasonAsInt < $1.seasonAsInt
                })
                let jolpyRepo = JolpyF1Repository()
                let drivers = await jolpyRepo.GetDrivers(
                    forYear: lastSeason!.seasonAsInt)
                return drivers?.MRData.DriverTable?.Drivers ?? []
            },
            isEnoughCachedFunction: { $0.count > 0 })

        let constructors = try await loadFromCacheOrGetFromRepo(
            repoLoadingFunction: {
                let lastSeason = seasons.max(by: {
                    $0.seasonAsInt < $1.seasonAsInt
                })
                let jolpyRepo = JolpyF1Repository()
                let constructors = await jolpyRepo.GetConstructors(
                    forYear: lastSeason!.seasonAsInt)
                return constructors?.MRData.ConstructorTable?.Constructors ?? []
            },
            isEnoughCachedFunction: { $0.count > 0 })

        try? await save(data: seasons)
        try? await save(data: drivers)
        try? await save(data: jolpyDrivers)
        try? await save(data: constructors)

        await MainActor.run {
            self.Seasons = seasons
            self.Drivers = drivers
            self.JolpyDrivers = jolpyDrivers
            self.Constructors = constructors
        }
    }

    func save<T: Encodable>(data: T) async throws {
        Task { @MainActor in
            let data = try JSONEncoder().encode(data)
            let outfile = try Self.fileURL(dataStore: "\(T.self)")
            try data.write(to: outfile)
        }
    }

    private func loadFromCache<T: Decodable>() async throws -> [T] {
        let task = Task<[T], Error> {
            let fileURL = try Self.fileURL(dataStore: "\([T].self)")
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let decoded = try JSONDecoder().decode([T].self, from: data)
            return decoded
        }
        let data = try await task.value
        return data
    }

    private func loadFromCacheOrGetFromRepo<T: Codable>(
        repoLoadingFunction: () async -> [T],
        isEnoughCachedFunction: (_: [T]) -> Bool
    ) async throws -> [T] {
        var cached: [T] = try await loadFromCache()
        if isEnoughCachedFunction(cached) == false {
            cached = await repoLoadingFunction()
        }
        return cached
    }
    
    func loadRaces(year: Int? = nil) async throws {
        let year = year ?? Calendar.current.component(.year, from: Date())

        var races = try await loadFromCacheOrGetFromRepo(
            repoLoadingFunction: {
                let jolpyRepo = JolpyF1Repository()
                let data = await jolpyRepo.GetRacesData(forYear: year)
                return data?.MRData.RaceTable?.Races ?? []
            },
            isEnoughCachedFunction: {
                return $0.contains(where: {
                    return Int($00.season) == year
                })
            })

        var meetings = try await loadFromCacheOrGetFromRepo(
            repoLoadingFunction: {
                if year < 2023 {
                    return [] as [Meeting]
                }
                let openF1Repo = OpenF1Repository()
                let meetings = await openF1Repo.LoadMeetingsData(forYear: year)
                return meetings ?? []
            },
            isEnoughCachedFunction: {
                return $0.contains(where: {
                    return $00.year == year
                })
            })
        
        //update results for prev and next races
        let prevRace = races.last(where: {$0.datetime! < Date()})
        if(prevRace?.Results?.isEmpty ?? true){
            let jolpyRepo = JolpyF1Repository()
            let results = await jolpyRepo.GetResults(forYear: Int(prevRace!.season)!, forRound: prevRace!.round)
            if(results != nil && results?.MRData.RaceTable != nil){
                let theResult = results?.MRData.RaceTable?.Races.first(where: { $0.round == prevRace!.round })
                if(theResult?.Results != nil){
                    var newPrevRace = prevRace!
                    newPrevRace.Results = theResult!.Results!
                    races.replace([prevRace!], with: [newPrevRace])
                }
            }
        }
        
        let nextRace = races.first(where: {Calendar.current.date(byAdding: .day, value: 1, to: $0.datetime!)! >= Date() })
        if(nextRace != nil && nextRace!.Results?.isEmpty ?? true){
            let jolpyRepo = JolpyF1Repository()
            let results = await jolpyRepo.GetResults(forYear: Int(nextRace!.season)!, forRound: nextRace!.round)
            if(results != nil && results?.MRData.RaceTable != nil){
                let theResult = results?.MRData.RaceTable?.Races.first(where: { $0.round == nextRace!.round })
                if(theResult?.Results != nil){
                    var newPrevRace = nextRace!
                    newPrevRace.Results = theResult!.Results!
                    races.replace([nextRace!], with: [newPrevRace])
                }
            }
        }
        
        if(nextRace != nil){
            let currentMeeting = meetings.first(where: {$0.meeting_name == nextRace!.raceName && $0.year == Int(nextRace!.season) })
            let openF1Repo = OpenF1Repository()
            let newMeetings = await openF1Repo.GetMeetings(forYear: year, name: nextRace!.raceName)
            if(newMeetings != nil && newMeetings?.count ?? 0 == 1){
                let newSessions = await openF1Repo.GetSessions(forYear: year, meetingKey: newMeetings!.first!.meeting_key)
                if(newSessions != nil) {
                    var finalMeeting: Meeting? = newMeetings!.first!
                    finalMeeting!.sessions = newSessions?.filter({$0.meeting_key == finalMeeting!.meeting_key})
                    if(currentMeeting != nil){
                        meetings.replace([currentMeeting!], with: [finalMeeting!])
                    }
                    else {
                        meetings.append(finalMeeting!)
                    }
                }
            }
                

            
        }
        
        
        let finalRaces = races

        await MainActor.run {
            let currentYear = Calendar.current.component(.year, from: Date())

            if year == currentYear {
                self.Races = finalRaces
                self.Meetings = meetings
            } else if year < currentYear {
                self.Races.insert(contentsOf: finalRaces, at: 0)
                self.Meetings.insert(contentsOf: meetings, at: 0)
            } else {
                self.Races.append(contentsOf: finalRaces)
                self.Meetings.append(contentsOf: meetings)
            }
        }

        try? await save(data: Races)
        try? await save(data: Meetings)
    }

}
