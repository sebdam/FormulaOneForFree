//
//  SeasonItemView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import SwiftUI

struct SeasonItemView: View {
    @Binding var season: Season
    var body: some View {
        Text($season.wrappedValue.season)
    }
}

#Preview {
    SeasonItemView(season: .constant(Season(season: "2024", url: "")))
}
