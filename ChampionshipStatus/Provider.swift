//
//  Provider.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 25/10/2024.
//
import UIKit
import WidgetKit

struct Provider: TimelineProvider {
    
    static var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter
    }()
    
    func computeDurations(from: Date, to: Date) -> String {
        let delta = from.timeIntervalSince(to)
        let duration = Provider.durationFormatter.string(from: delta)!
        return duration
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    driverStandings: DriverStanding(position: "2", positionText: "2", points: "42", wins: "12", Driver: JolpyDriver(driverId: "42", url: "", givenName: "Seb Dam", familyName: "Damiens-Cerf", dateOfBirth: "1979-04-25", nationality: "France", permanentNumber: nil, code: "SDC"), Constructors: [Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")]),
                    constructorStandings: ConstructorStanding(position: "42", positionText: "42", points: "12", wins: "6", Constructor: Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")),
                    driver: Driver(broadcast_name: "SDC", country_code: "SDC", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"),
                    driverImage: UIImage(named: "helmetWithDriver"), constructorImage: UIImage(named: "Ferrari"),
                    nextRace: "Mexico city championship",
                    countDown: "1d:2h:3m")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),
                                driverStandings: DriverStanding(position: "2", positionText: "2", points: "42", wins: "12", Driver: JolpyDriver(driverId: "42", url: "", givenName: "Seb Dam", familyName: "Damiens-Cerf", dateOfBirth: "1979-04-25", nationality: "France", permanentNumber: nil, code: "SDC"), Constructors: [Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")]),
                                constructorStandings: ConstructorStanding(position: "42", positionText: "42", points: "12", wins: "6", Constructor: Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")),
                                driver: Driver(broadcast_name: "SDC", country_code: "SDC", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"),
                                driverImage: UIImage(named: "helmetWithDriver"), constructorImage: UIImage(named: "Ferrari"),
                                nextRace: "Mexico city championship",
                                countDown: "1d:2h:3m")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let repoJolpyF1 = JolpyF1Repository()
            let currentYear = Calendar.current.component(.year, from: Date())
            
            let constructorsStandings = await repoJolpyF1.GetConstructorStandings(forYear: currentYear, forPosition: 1)
            let driversStandings = await repoJolpyF1.GetDriverStandings(forYear: currentYear, forPosition: 1)
            let firstDriverStanding = driversStandings?.MRData.StandingsTable?.StandingsLists.first?.DriverStandings?.first
            let firstConstructorStanding = constructorsStandings?.MRData.StandingsTable?.StandingsLists.first?.ConstructorStandings?.first
            
            let repoOpenF1 = OpenF1Repository()
            let drivers = await repoOpenF1.GetDrivers(name_acronym: firstDriverStanding?.Driver.code)
            let driver = drivers?.first
            
            var driverImage: UIImage? = nil
            if(driver?.headshot_url != nil){
                do {
                    let response = try await URLSession.shared.data(from: URL(string: driver!.headshot_url!)!)
                    driverImage = UIImage(data: response.0)?.resized(toWidth: 400, isOpaque: false)
                }
                catch {
                    print("Unexpected error while fetching driver image: \(error).")
                }
            }
            
            var constructorImage: UIImage? = nil
            if(firstConstructorStanding?.Constructor.name != nil){
                constructorImage = UIImage(named: firstConstructorStanding!.Constructor.name.replacingOccurrences(of: " ", with: "-"))?.resized(toWidth: 400, isOpaque: false)
            }
            
            let races = await repoJolpyF1.GetRaces(forYear: currentYear)
            let sortedRaces = races?.MRData.RaceTable?.Races.sorted(by: {$0.datetime! < $1.datetime!})
            var race:Race? = nil
            if(sortedRaces != nil){
                race = sortedRaces!.first(where: {$0.datetime! > Date()})
            }
            
            var entries : [SimpleEntry] = []
            let now = Date()
            for i in 0...15 {
                let duration = computeDurations(from: race?.datetime ?? Date(),
                                                to: Calendar.current.date(byAdding: .minute, value: i, to: now)!)
                let entry = SimpleEntry(date: Calendar.current.date(byAdding: .minute, value: i, to: now)!,
                                        driverStandings: firstDriverStanding,
                                        constructorStandings: firstConstructorStanding,
                                        driver: driver,
                                        driverImage: driverImage,
                                        constructorImage: constructorImage,
                                        nextRace: race?.raceName ?? "",
                                        countDown: duration)
                entries.append(entry)
            }
            
            
            
            let nextUpdate = Calendar.current.date(
                byAdding: DateComponents(minute: 15),
                to: Date()
            )!
            
            let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
            completion(timeline)
        }
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}
