//
//  ConstructorStandingView.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 23/10/2024.
//

import SwiftUI
import WidgetKit

struct ConstructorStandingView: View {
    @Binding var constructorStanding: ConstructorStanding
    @State var forWidget: Bool = false
    @State var image: UIImage? = nil
    @State var condensed: Bool = false
    var body: some View {
        HStack {
            if(forWidget) {
                if(image != nil) {
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
                    Text("\(constructorStanding.Constructor.name)")
                    if(!condensed){
                        Spacer()
                    }
                    Text("\(constructorStanding.wins) wins")
                    if(!condensed){
                        Spacer()
                    }
                    Text("\(constructorStanding.points) pts")
                    if(!condensed){
                        Spacer()
                    }
                }
                .frame(maxWidth:.infinity)
            }
            else {
                let teamImage = UIImage(named: constructorStanding.Constructor.name.replacingOccurrences(of: " ", with: "-"))
                
                if(teamImage != nil){
                    Image(uiImage: teamImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .clipShape(.rect(cornerRadius: 12))
                }
                else {
                    Image(systemName: "car")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .clipShape(.rect(cornerRadius: 12))
                }
                
                Text("\(constructorStanding.positionText != "-" ? "#" + constructorStanding.positionText : "")")
                
                if(!condensed){
                    Spacer()
                }
                
                Text("\(constructorStanding.Constructor.name)").frame(maxWidth: .infinity)
                if(!condensed){
                    Spacer()
                }
                Text("\(constructorStanding.wins) wins")
                if(!condensed){
                    Spacer()
                }
                Text("\(constructorStanding.points) pts")
            }
        }
        .font(.caption2)
    }
}

#Preview("For app") {
    ConstructorStandingView(constructorStanding: .constant(ConstructorStanding(position: "42", positionText: "42", points: "12", wins: "6", Constructor: Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy"))))
}
#Preview("For Widget with image", traits: .fixedLayout(width: 182, height: 170)) {
    ConstructorStandingView(constructorStanding: .constant(ConstructorStanding(position: "42", positionText: "42", points: "12", wins: "6", Constructor: Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy"))), forWidget: true, image: UIImage(named: "Ferrari"))
}
#Preview("For Widget without image", traits: .fixedLayout(width: 182, height: 170)) {
    ConstructorStandingView(constructorStanding: .constant(ConstructorStanding(position: "42", positionText: "42", points: "12", wins: "6", Constructor: Constructor(constructorId: "42", url: "", name: "Ferrari", nationality: "Italy"))), forWidget: true)
}
