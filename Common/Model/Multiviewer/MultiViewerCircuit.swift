//
//  MultiViewerCircuit.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 06/11/2024.
//

public struct MultiviewerCircuit: Codable {
    let circuitKey: Int
    let circuitName: String
    let rotation: Double
    let x: [Double]
    let y: [Double]
}
