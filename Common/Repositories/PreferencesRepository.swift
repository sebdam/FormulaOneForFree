//
//  PreferencesRepository.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 26/10/2024.
//
import Foundation

public class PreferencesRepository {
    public func readPreferences() -> Preferences {
        let driverId = Int(UserDefaults(suiteName: "group.com.dcsvision.FormulaOneForFree")!.string(forKey: "driver") ?? "0")!
        let constructorId = UserDefaults(suiteName: "group.com.dcsvision.FormulaOneForFree")!.string(forKey: "tream") ?? "0"
        
        return Preferences(driverId: driverId, constructorId: constructorId)
    }
    
    public func savePreferences(preferences: Preferences) {
        UserDefaults(suiteName: "group.com.dcsvision.FormulaOneForFree")!.setValue(preferences.driverId, forKey: "driver")
        UserDefaults(suiteName: "group.com.dcsvision.FormulaOneForFree")!.setValue(preferences.constructorId, forKey: "tream")
    }
}
