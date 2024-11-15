//
//  FormulaOneForFreeApp.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 19/10/2024.
//

import SwiftUI

@main
struct FormulaOneForFreeApp: App {
    @StateObject private var store = DataStore()
    
    var body: some Scene {
        WindowGroup {
            HomeView(seasons: $store.Seasons, drivers: $store.Drivers, jolpyDrivers: $store.JolpyDrivers, constructors: $store.Constructors)
                .task { @MainActor in
                    do {
                        try await store.load()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
        }
    }
}
