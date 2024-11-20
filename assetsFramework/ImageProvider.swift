//
//  ImageProvider.swift
//  FormulaOneForFree
//
//  Created by Sébastien Damiens-Cerf on 15/11/2024.
//
import UIKit

public class ImageProvider {
    public static func image(named: String) -> UIImage? {
        return UIImage(named: named, in: Bundle(for: self), with: nil)
    }
}
