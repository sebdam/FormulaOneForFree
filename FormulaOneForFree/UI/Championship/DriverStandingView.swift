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
    
    var body: some View {
        HStack {
            if(forWidget && image != nil) {
                Image(uiImage: image!)
                    .resizable()
                    .frame(width: forWidget ? 25 : 50, height: forWidget ? 25 : 50)
                    .clipShape(.rect(cornerRadius: 12))
                
                Spacer()
            }
            else if(!forWidget && driver?.headshot_url != nil) {
                AsyncImage(url: URL(string: driver!.headshot_url!)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: forWidget ? 25 : 50, height: forWidget ? 25 : 50)
                .clipShape(.rect(cornerRadius: 12))
            }
            else if(!forWidget) {
                Image("helmetWithDriver")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(.rect(cornerRadius: 12))
            }
            
            if(!forWidget) {
                Text("#\(driverStanding.positionText)")
                Spacer()
            }
            
            VStack {
                if(forWidget && image == nil) {
                    Text("\(driverStanding.Driver.code ?? driverStanding.Driver.driverId)")
                }
                else {
                    Text("\(driverStanding.Driver.givenName) \(driverStanding.Driver.familyName)")
                }
                
                Text("\(driverStanding.wins) wins")
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            Text("\(driverStanding.points) pts").frame(maxWidth: .infinity)
        }
        .font(.caption2)
    }
}

#Preview {
    DriverStandingView(driverStanding: .constant(
        DriverStanding(position: "2", positionText: "2", points: "42", wins: "12", Driver: JolpyDriver(driverId: "42", url: "", givenName: "Seb Dam", familyName: "Damiens-Cerf", dateOfBirth: "1979-04-25", nationality: "France", permanentNumber: "42", code: "SDC"), Constructors: [Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy")])),
        driver: .constant(
            Driver(broadcast_name: "SDC", country_code: "SDC", driver_number: 42, first_name: "Sébastien", full_name: "Sébastien Damiens-Cerf", headshot_url: "", last_name: "Damiens-Cerf", meeting_key: 42, name_acronym: "SDC", session_key: 42, team_colour: nil, team_name: "Ferrari"))
    )
}
