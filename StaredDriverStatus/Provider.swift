//
//  Provider.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 02/11/2024.
//
import UIKit
import WidgetKit

extension WidgetTimeLineProvider : TimelineProvider {
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getStaredTimeline(in: context, completion: completion)
    }
}
