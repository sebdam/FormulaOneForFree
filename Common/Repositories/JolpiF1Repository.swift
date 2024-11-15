//
//  JolpiF1Repository.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 19/10/2024.
//

import Foundation

public class JolpyF1Repository {
    private let baseUrl = "https://api.jolpi.ca/ergast/f1"
    
    public func GetSeasons() async -> JolpiRacesData? {
        let url = baseUrl + "/seasons/?format=json&limit=100"
        let response:JolpiRacesData? = await fetch(url: url)
        if(response?.MRData.SeasonTable != nil){
            var newResponse = response!
            newResponse.MRData.SeasonTable!.Seasons.sort(by: { $0.season > $1.season })
            return newResponse
        }
        return nil
    }
    
    public func GetRacesData(forYear:Int) async -> JolpiRacesData? {
        let url = baseUrl + "/\(forYear)/races/?format=json"
        
        let response:JolpiRacesData? = await fetch(url: url)
        
        if(response?.MRData.RaceTable?.Races != nil){
            var finalResponse = response!
            finalResponse.MRData.RaceTable!.Races = []
            for race in response!.MRData.RaceTable!.Races {
                var finalRace = race
                
                try! await Task.sleep(nanoseconds: UInt64(0.5 * Double(NSEC_PER_SEC)))
                let results = await GetResults(forYear: forYear, forRound: race.round)
                
                if(results != nil && results?.MRData.RaceTable != nil){
                    let theResult = results?.MRData.RaceTable?.Races.first(where: { $0.round == race.round })
                    if(theResult?.Results != nil){
                        finalRace.Results = theResult!.Results!
                    }
                    finalResponse.MRData.RaceTable!.Races.append(finalRace)
                }
            }
            
            return finalResponse
        }
        
        return response
    }
    
    public func GetRaces(forYear:Int) async -> JolpiRacesData? {
        let url = baseUrl + "/\(forYear)/races/?format=json"
        let response:JolpiRacesData? = await fetch(url: url)
        return response
    }
    
    public func GetDrivers(forYear:Int, driverId: String? = nil) async -> JolpiRacesData? {
        var url = baseUrl + "/\(forYear)/drivers/"
        if(driverId != nil){
            url = url + "\(driverId!)/"
        }
        url = url + "?format=json&limit=100"
        let response:JolpiRacesData? = await fetch(url: url)
        return response
    }
    
    public func GetResults(forYear:Int, forRound:String) async -> JolpiRacesData? {
        let url = baseUrl + "/\(forYear)/\(forRound)/results/?format=json&limit=100"
        print("\(url)")
        let response:JolpiRacesData? = await fetch(url: url)
        return response
    }
    
    public func GetDriverStandings(forYear:Int, forPosition:Int? = nil, forDriverId:String? = nil) async -> JolpiRacesData? {
        var url = baseUrl + "/\(forYear)/"
        if(forDriverId != nil){
            url = url + "drivers/\(forDriverId!)/"
        }
        url = url + "driverstandings/"
        if(forPosition != nil){
            url = url + "\(forPosition!)/"
        }
        url = url+"?format=json&limit=100"
        let response:JolpiRacesData? = await fetch(url: url)
        return response
    }
    
    public func GetConstructorStandings(forYear:Int, forPosition:Int? = nil, forConstructorId:String? = nil) async -> JolpiRacesData? {
        var url = baseUrl + "/\(forYear)/"
        if(forConstructorId != nil){
            url = url + "constructors/\(forConstructorId!)/"
        }
        url = url + "constructorstandings/"
        if(forPosition != nil){
            url = url + "\(forPosition!)/"
        }
        url = url+"?format=json&limit=100"
        let response:JolpiRacesData? = await fetch(url: url)
        return response
    }
    
    public func GetConstructors(forYear:Int) async -> JolpiRacesData? {
        let url = baseUrl + "/\(forYear)/constructors/?format=json&limit=100"
        let response:JolpiRacesData? = await fetch(url: url)
        return response
    }
    
    public func GetCircuits() async -> JolpiRacesData? {
        let url = baseUrl + "/circuits/?format=json&limit=100"
        let response:JolpiRacesData? = await fetch(url: url)
        return response
    }
    
    func fetch<T: Decodable>(url: String) async -> T? {
        do {
            let response = try await URLSession.shared.data(from: URL(string: url)!)
            
            if let httpResponse = response.1 as? HTTPURLResponse? {
                if !(200...299).contains(httpResponse!.statusCode) {
                    // handle HTTP server-side error
                    if let responseString = String(bytes: response.0, encoding: .utf8) {
                        // The response body seems to be a valid UTF-8 string, so print that.
                        // This will probably be `{"message": "unable to login"}`
                        print("JolpyF1Repository statuscode : \(httpResponse!.statusCode)")
                        print(responseString)
                    } else {
                        print("JolpyF1Repository statuscode : \(httpResponse!.statusCode)")
                    }
                    return nil
                }
            }
            
            return try JSONDecoder().decode(T.self, from: response.0)
        }
        catch {
            print("Unexpected error while fetching from JolpyF1Repository: \(error).")
        }
        
        return nil
    }
}
