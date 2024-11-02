//
//  Provider.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 25/10/2024.
//
import UIKit
import WidgetKit

extension WidgetTimeLineProvider : TimelineProvider {
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getChampionshipTimeline(in: context, completion: completion)
    }
}
