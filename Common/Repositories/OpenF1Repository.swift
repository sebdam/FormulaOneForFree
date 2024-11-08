//
//  OpenF1Repository.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 19/10/2024.
//

import Foundation

public class OpenF1Repository {
    private let baseUrl = "https://api.openf1.org/v1"
    
    public func GetMeetings(forYear:Int, name:String? = nil) async -> [Meeting]? {
        var url = baseUrl + "/meetings?year=\(forYear)"
        if(name != nil){
            url = url + "&meeting_name=\(name!)"
        }
        let response:[Meeting]? = await fetch(url: url)
        return response
    }
    
    public func GetSessions(forYear:Int, meetingKey: Int? = nil) async -> [Session]? {
        var url = baseUrl + "/sessions?year=\(forYear)"
        if(meetingKey != nil){
            url = url + "&meeting_key=\(meetingKey!)"
        }
        let response:[Session]? = await fetch(url: url)
        return response
    }
    
    public func GetPostions(meetingKey:Int, sessionKey: Int? = nil) async -> [Position]? {
        var url = baseUrl + "/position?meeting_key=\(meetingKey)"
        if(sessionKey != nil){
            url = url + "&session_key=\(sessionKey!)"
        }
        let response:[Position]? = await fetch(url: url)
        return response
    }
    
    public func GetLaps(meetingKey:Int, sessionKey: Int? = nil, driverNumber:Int? = nil) async -> [Lap]? {
        var url = baseUrl + "/laps?meeting_key=\(meetingKey)"
        if(driverNumber != nil){
            url = url + "&driver_number=\(driverNumber!)"
        }
        if(sessionKey != nil){
            url = url + "&session_key=\(sessionKey!)"
        }
        let response:[Lap]? = await fetch(url: url)
        return response
    }
    
    public func GetDriversLocations(meetingKey:Int, sessionKey: Int, driverNumber:Int? = nil, since: Date, to: Date? = nil) async -> [DriverLocation]? {
        var url = baseUrl + "/location?meeting_key=\(meetingKey)&session_key=\(sessionKey)"
        if(driverNumber != nil){
            url = url + "&driver_number=\(driverNumber!)"
        }
        
        var to = to
        if(to == nil){
            to = Calendar.current.date(byAdding: .second, value: 1, to: since)!
        }
        url = url + "&date>=\(since.ISO8601Format())&date<\(to!.ISO8601Format())"
        
        print("\(url)")
        let response:[DriverLocation]? = await fetch(url: url)
        return response
    }
    
    public func GetDrivers(driver_number:Int? = nil, name_acronym:String? = nil) async -> [Driver]? {
        var url = baseUrl + "/drivers"
        if(driver_number != nil){
            url = url + "?driver_number=\(driver_number!)"
        }
        if(name_acronym != nil){
            url = url + "?name_acronym=\(name_acronym!)"
        }
        let response:[Driver]? = await fetch(url: url)
        
        if(response != nil){
            var drivers:[Driver] = []
            let drivers_number = response?.map({$0.driver_number}).unique()
            for driver_number in drivers_number!{
                let driver = response!.last(where: {$0.driver_number == driver_number})!
                drivers.append(driver)
            }
            return drivers
        }
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
                        print("OpenF1Repository statuscode : \(httpResponse!.statusCode)")
                        print(responseString)
                    } else {
                        print("OpenF1Repository statuscode : \(httpResponse!.statusCode)")
                    }
                    return nil
                }
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601withOptionalFractionalSeconds
            return try decoder.decode(T.self, from: response.0)
        }
        catch {
            print("Unexpected error while fetching from OpenF1Repository: \(error).")
        }
        
        return nil
    }
    
    public func LoadMeetingsData(forYear: Int) async -> [Meeting]? {
        let meetings = await GetMeetings(forYear: forYear)
        let sessions = await GetSessions(forYear: forYear)
        
        var finalMeetings: [Meeting] = []
        
        if(meetings != nil && sessions != nil) {
            for var meeting in meetings!{
                meeting.sessions = sessions?.filter({$0.meeting_key == meeting.meeting_key})
                finalMeetings.append(meeting)
            }
        }
        
        return finalMeetings
    }
    
    public func LoadSessionData(session: Session) async -> Session {
        var newSession = session
        let positions = await GetPostions(meetingKey: session.meeting_key, sessionKey: session.session_key)
        let laps = await GetLaps(meetingKey: session.meeting_key, sessionKey: session.session_key)
        
        if(positions != nil){
            var positionsOfSession = positions!
            positionsOfSession.sort(by: {
                $0.date > $1.date
            })
            
            let max = positionsOfSession.map(\.self.position).max()
            if(max != nil){
                var finalPositions: [Position] = []
                if(laps != nil){
                    let lapsOfSession = laps!
                    
                    for i in 1...max!{
                        var position = positionsOfSession.first(where: { $0.position == i })!
                        position.laps = lapsOfSession.filter({$0.driver_number == position.driver_number})
                        finalPositions.append(position)
                    }
                    newSession.positions = finalPositions
                }
            }
        }
        return newSession
    }
}
