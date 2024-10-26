//
//  Entry.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 25/10/2024.
//
import UIKit
import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let driverStandings: DriverStanding?
    let constructorStandings: ConstructorStanding?
    let driver: Driver?
    let driverImage: UIImage?
    let constructorImage: UIImage?
    let nextRace: String
    let countDown: String
}
