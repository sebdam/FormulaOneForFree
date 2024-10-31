//
//  DriverStandingView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import SwiftUI

struct DriverStandingView: View {
    @Binding var driverStanding: DriverStanding
    @Binding var driver: Driver?
    @State var forWidget: Bool = false
    @State var image: UIImage? = nil
    @State var condensed: Bool = false
    
    var body: some View {
        HStack {
            if(forWidget) {
                if(image != nil){
                    Image(uiImage: image!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .clipShape(.rect(cornerRadius: 12))
                }
                
                VStack {
                    if(!condensed){
                        Spacer()
                    }
                    if(image != nil){
                        Text("\(driverStanding.Driver.givenName) \(driverStanding.Driver.familyName)")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("\(driverStanding.Driver.code ?? driverStanding.Driver.driverId)")
                            .frame(maxWidth: .infinity)
                    }
                    if(!condensed){
                        Spacer()
                    }
                    Text("\(driverStanding.wins) wins")
                    if(!condensed){
                        Spacer()
                    }
                    Text("\(driverStanding.points) pts")
                    if(!condensed){
                        Spacer()
                    }
                }.frame(maxWidth: .infinity)
            }
            else if(!forWidget) {
                if(driver?.headshot_url != nil){
                    AsyncImage(url: URL(string: driver!.headshot_url!)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(width: forWidget ? 25 : 50, height: forWidget ? 25 : 50)
                    .clipShape(.rect(cornerRadius: 12))
                }
                else {
                    Image("helmetWithDriver")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 12))
                }
                
                Text("\(driverStanding.positionText != "-" ? "#"+driverStanding.positionText : "")")
                if(!condensed){
                    Spacer()
                }
                Text("\(driverStanding.Driver.givenName) \(driverStanding.Driver.familyName)")
                    .frame(maxWidth: .infinity)
                if(!condensed){
                    Spacer()
                }
                Text("\(driverStanding.wins) wins")
                Text("\(driverStanding.points) pts")
            }
        }
        .font(.caption2)
    }
}

#Preview("For app") {
    DriverStandingView(driverStanding: .constant(
        DriverStanding(position: "2", positionText: "2", points: "42", wins: "12", Driver: JolpyDriver(driverId: "42", url: "", givenName: "Seb Dam", familyName: "Damiens-Cerf", dateOfBirth: "1979-04-25", nationality: "France", permanentNumber: "42", code: "SDC"), Constructors: [Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")])),
        driver: .constant(
            Driver(broadcast_name: "SDC", country_code: "SDC", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"))
    )
}

#Preview("For Widget with image", traits: .fixedLayout(width: 182, height: 170)) {
    DriverStandingView(driverStanding: .constant(
        DriverStanding(position: "2", positionText: "2", points: "42", wins: "12", Driver: JolpyDriver(driverId: "42", url: "", givenName: "Seb Dam", familyName: "Damiens-Cerf", dateOfBirth: "1979-04-25", nationality: "France", permanentNumber: "42", code: "SDC"), Constructors: [Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")])),
        driver: .constant(
            Driver(broadcast_name: "SDC", country_code: "SDC", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari")),
        forWidget: true,
        image: UIImage(named: "Ferrari"))
}
#Preview("For Widget without image", traits: .fixedLayout(width: 182, height: 170)) {
    DriverStandingView(driverStanding: .constant(
        DriverStanding(position: "2", positionText: "2", points: "42", wins: "12", Driver: JolpyDriver(driverId: "42", url: "", givenName: "Seb Dam", familyName: "Damiens-Cerf", dateOfBirth: "1979-04-25", nationality: "France", permanentNumber: "42", code: "SDC"), Constructors: [Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")])),
        driver: .constant(
            Driver(broadcast_name: "SDC", country_code: "SDC", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari")),
        forWidget: true)
}
