//
//  File.swift
//  
//
//  Created by Charles Yiu on 8/11/2023.
//

import Foundation
import AppIconSetGen
import CoreImage

do {
    try generateAppIconSet(image: CIImage(color: .blue).cropped(to: .init(x: 0, y: 0, width: 200, height: 300)), types: [.iOS, .watchOS, .macOS], name: "Blue", output: .init(string: "file:///Users/charlesyiu/blue")!)
} catch {
    print(error)
}
