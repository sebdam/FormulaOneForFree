//
//  SessionResultsView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 20/10/2024.
//

import SwiftUI

struct SessionResultItemView: View {
    @State var positions = 1
    
    @State var driverUrl : String?
    @State var driverName : String
    
    @State var team: String?
    @State var teamColor: String?
    
    @State var bestLapDuration: Double?
    @State var sessionDuration: Double?
    
    @State var status: String?
    
    func numberFormatter() -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }
    
    var body: some View {
        HStack {
            
            if(driverUrl != nil) {
                AsyncImage(url: URL(string: driverUrl!)) { image in
                    image.resizable()
                } placeholder: {
                    Color.red
                }
                .frame(width: 50, height: 50)
                .clipShape(.rect(cornerRadius: 12))
            }
            else {
                Image("helmetWithDriver")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(.rect(cornerRadius: 12))
            }
            
            Text("#\(positions)")
            
            VStack {
                Text("\(driverName)")
                if(team != nil){
                    AsyncImage(url: URL(string: "https://media.formula1.com/d_team_car_fallback_image.png/content/dam/fom-website/teams/2024/\(team!.replacingOccurrences(of: " ", with: "-")).png")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.red
                    }
                    .frame(width: 87, height: 25)
                    .clipShape(.rect(cornerRadius: 12))
                    
                    Text("\(team!)").font(.caption2)
                }
                
            }
            .frame(maxWidth: .infinity)
            
            
            VStack {
                if(bestLapDuration != nil){
                    HStack{
                        Image(systemName: "stopwatch")
                        
                        let number =  numberFormatter().string(from: NSNumber(value: bestLapDuration!))
                        if(number != nil){
                            Text("\(number!) s")
                        }
                    }
                }
                
                if(sessionDuration != nil){
                    HStack {
                        Image(systemName: "hourglass")
                        
                        let duration = Duration.seconds(sessionDuration!)
                        Text(duration.formatted())
                    }
                }
                
                if(status != nil){
                    Text(status!)
                }
            }
        }
        .font(.caption)
        .padding([.trailing])
        
    }
    
}

#Preview() {
    SessionResultItemView(positions: 1, driverName: "Seb DC", team:"Red Bull Racing", teamColor: "#ffe700ff", bestLapDuration: 153.42, sessionDuration: 6547.23)
    
    SessionResultItemView(positions: 1, driverName: "Seb DC", team:"Red Bull Racing", teamColor: "#3671C6", bestLapDuration: 153.42, sessionDuration: 6547.23)
}
