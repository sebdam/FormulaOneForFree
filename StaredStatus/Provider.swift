//
//  Provider.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 26/10/2024.
//
import UIKit
import WidgetKit

struct StaredProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    driverStandings: DriverStanding(position: "2", positionText: "2", points: "42", wins: "12", Driver: JolpyDriver(driverId: "42", url: "", givenName: "Seb Dam", familyName: "Damiens-Cerf", dateOfBirth: "1979-04-25", nationality: "France", permanentNumber: nil, code: "SDC"), Constructors: [Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")]),
                    constructorStandings: ConstructorStanding(position: "42", positionText: "42", points: "12", wins: "6", Constructor: Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")),
                    driver: Driver(broadcast_name: "SDC", country_code: "SDC", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"),
                    driverImage: nil, constructorImage: nil,
                    nextRace: "", countDown: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),
                                driverStandings: DriverStanding(position: "2", positionText: "2", points: "42", wins: "12", Driver: JolpyDriver(driverId: "42", url: "", givenName: "Seb Dam", familyName: "Damiens-Cerf", dateOfBirth: "1979-04-25", nationality: "France", permanentNumber: nil, code: "SDC"), Constructors: [Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")]),
                                constructorStandings: ConstructorStanding(position: "42", positionText: "42", points: "12", wins: "6", Constructor: Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")),
                                driver: Driver(broadcast_name: "SDC", country_code: "SDC", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"),
                                driverImage: nil, constructorImage: nil,
                                nextRace: "",
                                countDown: "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let prefRepo = PreferencesRepository()
            let preferences = prefRepo.readPreferences()
            
            let repoJolpyF1 = JolpyF1Repository()
            let currentYear = Calendar.current.component(.year, from: Date())
            let jolpyDrivers = await repoJolpyF1.GetDrivers(forYear: currentYear, driverId: preferences.driverId)
            let jolpyDriver = jolpyDrivers?.MRData.DriverTable?.Drivers.first
            
            let constructorsStandings = await repoJolpyF1.GetConstructorStandings(forYear: currentYear, forConstructorId: preferences.constructorId)
            let driversStandings = await repoJolpyF1.GetDriverStandings(forYear: currentYear, forDriverId: preferences.driverId)
            
            let firstConstructorStanding = constructorsStandings?.MRData.StandingsTable?.StandingsLists.first?.ConstructorStandings?.first
            let firstDriverStanding = driversStandings?.MRData.StandingsTable?.StandingsLists.first?.DriverStandings?.first
            
            var constructorImage: UIImage? = nil
            if(firstConstructorStanding?.Constructor.name != nil){
                constructorImage = UIImage(named: firstConstructorStanding!.Constructor.name.replacingOccurrences(of: " ", with: "-"))?.resized(toWidth: 400, isOpaque: false)
            }
            
            var driverImage: UIImage? = nil
            var driver: Driver? = nil
            
            if(jolpyDriver?.code != nil){
                let repoOpenF1 = OpenF1Repository()
                let drivers = await repoOpenF1.GetDrivers(name_acronym: jolpyDriver?.code)
                driver = drivers?.first
                
                if(driver?.headshot_url != nil){
                    do {
                        let response = try await URLSession.shared.data(from: URL(string: driver!.headshot_url!)!)
                        driverImage = UIImage(data: response.0)?.resized(toWidth: 400, isOpaque: false)
                    }
                    catch {
                        print("Unexpected error while fetching driver image: \(error).")
                    }
                }
            }
            
            let entry = SimpleEntry(date: Date(),
                                      driverStandings: firstDriverStanding,
                                      constructorStandings: firstConstructorStanding,
                                      driver: driver,
                                      driverImage: driverImage,
                                      constructorImage: constructorImage,
                                      nextRace: "",
                                      countDown: "")
            
            let nextUpdate = Calendar.current.date(
                byAdding: DateComponents(minute: 15),
                to: Date()
            )!
            
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}
