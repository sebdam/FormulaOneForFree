//
//  DriverView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 27/10/2024.
//

import SwiftUI
import CachedAsyncImage

struct DriverView: View {
    @State var driver: Driver
    @State var bestLapDuration: Double? = nil
    @State var position: String
    @State var height: CGFloat?
    @State var alignBottom: Bool = true
    
    
    func numberFormatter() -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }
    
    var body: some View {
        VStack {
            let driverUrl = driver.headshot_url
            let team = driver.team_name
            
            if(alignBottom) {
                Spacer()
            }
            
            if(driverUrl != nil) {
                CachedAsyncImage(url: URL(string: driverUrl!)) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .font(.title)
                            .foregroundStyle(.secondary)
                    } else {
                        ProgressView()
                    }
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
            
            Text(driver.name_acronym)
            
            if(bestLapDuration != nil){
                HStack{
                    Image(systemName: "stopwatch")
                    
                    let number =  numberFormatter().string(from: NSNumber(value: bestLapDuration!))
                    if(number != nil){
                        Text("\(number!) s")
                    }
                }
            }
            
            if(height != nil){
                Spacer().frame(height: height!)
            }
            
            if(team != nil){
                CachedAsyncImage(url: URL(string: "https://media.formula1.com/d_team_car_fallback_image.png/content/dam/fom-website/teams/2024/\(team!.replacingOccurrences(of: " ", with: "-")).png")) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .font(.title)
                            .foregroundStyle(.secondary)
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 87, height: 25)
                .clipShape(.rect(cornerRadius: 12))
                
                Text("\(team!)").font(.caption2)
            }
            
            if(!position.isEmpty) {
                Text(position)
            }
        }
        .frame(maxWidth:.infinity)
    }
}

#Preview {
    DriverView(driver: Driver(broadcast_name: "SDC", country_code: "FRA", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "https://www.formula1.com/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png.transform/1col/image.png", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"),
               bestLapDuration: 42,
               position: "12",
               height: 20)
}
