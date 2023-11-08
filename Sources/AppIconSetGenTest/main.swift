//
//  File.swift
//  
//
//  Created by Charles Yiu on 8/11/2023.
//

import Foundation
import CoreImage
import AppIconSetGen

// A solid blue square with dimensions of 200x200
let blueSquare = CIImage(color: .blue).cropped(to: .init(x: 0, y: 0, width: 200, height: 200))

// Would export for iOS, watchOS, and macOS
let iconTypes = [AppIconSetType.iOS, AppIconSetType.watchOS, AppIconSetType.macOS]

// Would export to ~/blue/blue.appiconset
let outputName = "blue"
let outputDir = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("blue")

do {
    try generateAppIconSet(image: blueSquare, types: iconTypes, name: outputName, output: outputDir)
} catch {
    print(error)
}
