//
//  Formula1Repository.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 19/10/2024.
//
// https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/las_vegas_Circuit


import Foundation
import UIKit

public class FormulaOneRepository {
    public static func GetCircuitImageUrl(_ circuit: Circuit) -> String {
        let name = ComputeName(circuitName: circuit.circuitName)
        let ville = ComputeCity(circuitName: circuit.circuitName)
        return "https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/\(name)_circuit\(ville)"
    }
    
    private static func ComputeName(circuitName: String) -> String {
        var name = circuitName.replacingOccurrences(of: " ", with: "_")
        if(name == "Hockenheimring"){
            name = "Germany"
        }
        else if(name == "Autodromo_Internazionale_del_Mugello"){
            name = "Tuscany"
        }
        else if(name == "Nürburgring"){
            name = "Eifel"
        }
        else if(name == "Autódromo_Internacional_do_Algarve"){
            name = "Portugal"
        }
        else if(name == "Istanbul_Park"){
            name = "Turkey"
        }
        else if(name == "Sochi_Autodrom"){
            name = "Russia"
        }
        else if(name == "Circuit_Paul_Ricard"){
            name = "France"
        }
        else if(name == "Bahrain_International_Circuit"){
            name = "Bahrain"
        }
        else if(name == "Jeddah_Corniche_Circuit"){
            name = "Saudi_Arabia"
        }
        else if(name == "Albert_Park_Grand_Prix_Circuit"){
            name = "Austria"
        }
        else if(name == "Suzuka_Circuit"){
            name = "Japan"
        }
        else if(name == "Shanghai_International_Circuit"){
            name = "China"
        }
        else if(name == "Miami_International_Autodrome"){
            name = "Miami"
        }
        else if(name == "Autodromo_Enzo_e_Dino_Ferrari"){
            name = "Emilia_Romagna"
        }
        else if(name == "Circuit_de_Monaco"){
            name = "Monaco"
        }
        else if(name == "Circuit_Gilles_Villeneuve"){
            name = "Canada"
        }
        else if(name == "Circuit_de_Barcelona-Catalunya"){
            name = "Spain"
        }
        else if(name == "Red_Bull_Ring"){
            name = "Austria"
        }
        else if(name == "Silverstone_Circuit"){
            name = "Great_Britain"
        }
        else if(name == "Hungaroring"){
            name = "Hungary"
        }
        else if(name == "Circuit_de_Spa-Francorchamps"){
            name = "Belgium"
        }
        else if(name == "Circuit_Park_Zandvoort"){
            name = "Netherlands"
        }
        else if(name == "Autodromo_Nazionale_di_Monza"){
            name = "Italy"
        }
        else if(name == "Baku_City_Circuit"){
            name = "Baku"
        }
        else if(name == "Marina_Bay_Street_Circuit"){
            name = "Singapore"
        }
        else if(name == "Circuit_of_the_Americas"){
            name = "USA"
        }
        else if(name == "Autódromo_Hermanos_Rodríguez"){
            name = "Mexico"
        }
        else if(name == "Autódromo_José_Carlos_Pace"){
            name = "Brazil"
        }
        else if(name == "Las_Vegas_Strip_Street_Circuit"){
            name = "Las_Vegas"
        }
        else if(name == "Losail_International_Circuit"){
            name = "Qatar"
        }
        else if(name == "Yas_Marina_Circuit"){
            name = "Abu_Dhabi"
        }
        
        return name
    }
    
    private static func ComputeCity(circuitName: String) -> String {
        let name = circuitName.replacingOccurrences(of: " ", with: "_")
        var ville = ""
        if(name == "Hockenheimring"){
            ville = "_Hockenheim"
        }
        return ville
    }
}
