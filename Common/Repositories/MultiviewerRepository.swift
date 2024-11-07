//
//  MultiviewerRepository.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 06/11/2024.
//

import Foundation

public class MultiviewerRepository {
    private let baseUrl = "https://api.multiviewer.app/api/v1"
    
    public func GetCircuit(forYear:Int, key:Int) async -> MultiviewerCircuit? {
        let url = baseUrl + "/circuits/\(key)/\(forYear)"
        let response:MultiviewerCircuit? = await fetch(url: url)
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
                        print("Multiviewerepository statuscode : \(httpResponse!.statusCode)")
                        print(responseString)
                    } else {
                        print("Multiviewerepository statuscode : \(httpResponse!.statusCode)")
                    }
                    return nil
                }
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601withOptionalFractionalSeconds
            return try decoder.decode(T.self, from: response.0)
        }
        catch {
            print("Unexpected error while fetching from Multiviewerepository: \(error).")
        }
        
        return nil
    }
    
}
