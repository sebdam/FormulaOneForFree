//
//  ConstructorStandingView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import SwiftUI

struct ConstructorStandingView: View {
    @Binding var constructorStanding: ConstructorStanding
    var body: some View {
        HStack {
            
            AsyncImage(url: URL(string: "https://media.formula1.com/d_team_car_fallback_image.png/content/dam/fom-website/teams/2024/\(constructorStanding.Constructor.constructorId.replacingOccurrences(of: "_", with: "-")).png")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 87, height: 25)
            .clipShape(.rect(cornerRadius: 12))
            
            Text("#\(constructorStanding.positionText)")
            Spacer()
            VStack {
                Text("\(constructorStanding.Constructor.name)")
                Text("\(constructorStanding.wins) wins")
            }
            Spacer()
            Text("\(constructorStanding.points) pts")
        }
    }
}

#Preview {
    ConstructorStandingView(constructorStanding: .constant(ConstructorStanding(position: "42", positionText: "42", points: "12", wins: "6", Constructor: Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy"))))
}
