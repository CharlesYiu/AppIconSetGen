//
//  AppIconSet.swift
//  AppIconSetGen
//
//  Created by Attila Bencze on 11/05/2017.
//
//

//import Cocoa
//import Commander
import Foundation
import CoreImage
import AppKit

//let version = "0.0.2"
//let main = command(
//    Argument<String>("input file", description: "Path to an image file (.pdf, .png, etc)"),
//    Flag("iOS", description: "Generates app icons for iOS"),
//    Flag("watchOS", description: "Generates app icons for watchOS"),
//    Flag("macOS", description: "Generates app icons for macOS"),
//    Option("output", default: ".", description: "Output folder of the generated App Icon set"),
//    Option("appIconSetName", default: "AppIcon", description: "App icon set name")
//) { inputFile, iOS, watchOS, macOS, output, appIconSetName in
//
//    guard iOS || watchOS || macOS else {
//        throw "At least one of --iOS, --watchOS or --macOS flag must be specified!"
//    }
//
//    guard let image = NSImage(byReferencingFile: inputFile), image.isValid else {
//        throw "Unable to open file: \(inputFile)!"
//    }
//
//    var iconInfoItems = [IconInfo]()
//
//    if iOS {
//        iconInfoItems += iconInfoItemsIOS
//    }
//
//    if watchOS {
//        iconInfoItems += iconInfoItemsWatchOS
//    }
//
//    if macOS {
//        iconInfoItems += iconInfoItemsMacOS
//    }
//
//    print("Generating app icons...")
//    let appIconSet = AppIconSet(iconInfoItems: iconInfoItems)
//    try appIconSet.createOnDisk(sourceImage: image, outputFolderPath: output, appIconSetName: appIconSetName)
//
//    print("Done!")
//}

private func convertCIImageToNSImage(image: CIImage) -> NSImage {
    let imageRep = NSCIImageRep(ciImage: image)
    let convertedImage: NSImage = NSImage(size: imageRep.size)
    convertedImage.addRepresentation(imageRep)
    return convertedImage
}

public enum AppIconSetType {
    case iOS
    case watchOS
    case macOS
}

public func generateAppIconSet(image: NSImage, types: [AppIconSetType], name: String, output: URL) throws {
    if (types.isEmpty)  {
        return
    }
    
    var iconInfoItems = [IconInfo]()
    
    types.forEach { type in
        switch type {
        case .iOS:
            iconInfoItems += iconInfoItemsIOS
        
        case .watchOS:
            iconInfoItems += iconInfoItemsWatchOS
        
        case .macOS:
            iconInfoItems += iconInfoItemsMacOS
        
        }
    }
    
    print("Generating app icons...")
    let appIconSet = AppIconSet(iconInfoItems: iconInfoItems)
    try appIconSet.createOnDisk(sourceImage: image, outputFolderPath: output, appIconSetName: name)

    print("Done!")
}

public func generateAppIconSet(image: NSImage, type: AppIconSetType, name: String, output: URL) throws {
    return try generateAppIconSet(image: image, types: [type], name: name, output: output)
}

public func generateAppIconSet(image: CIImage, types: [AppIconSetType], name: String, output: URL) throws {
    return try generateAppIconSet(image: convertCIImageToNSImage(image: image), types: types, name: name, output: output)
}

public func generateAppIconSet(image: CIImage, type: AppIconSetType, name: String, output: URL) throws {
    return try generateAppIconSet(image: image, types: [type], name: name, output: output)
}
