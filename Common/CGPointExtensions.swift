//
//  CGPointExtensions.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 07/11/2024.
//
import Foundation

extension CGPoint {
    public func rotate(angle:Double, flipX: Bool = false, flipY: Bool = false) -> CGPoint {
        let radian = angle / 180 * .pi
        let newX = (x * cos(radian) * (flipX ? -1.0 : 1.0)) - (y * sin(radian) * (flipY ? -1.0 : 1.0))
        let newY = (x * sin(radian) * (flipX ? -1.0 : 1.0)) + (y * cos(radian) * (flipY ? -1.0 : 1.0))
        return CGPoint(x: newX, y: newY)
    }
}
