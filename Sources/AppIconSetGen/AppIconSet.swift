//
//  AppIconSet.swift
//  AppIconSetGenCore
//
//  Created by Attila Bencze on 11/05/2017.
//
//

import Cocoa
import Foundation

struct AppIconSet {
    let iconInfoItems: [IconInfo]
    let fileManager = FileManager()

    func createOnDisk(sourceImage: NSImage, outputFolderPath: URL, appIconSetName: String) throws {
        let items = iconInfoItems
        let imageSizesInPixels = items.reduce(into: Set<CGFloat>()) { (result: inout Set<CGFloat>, iconInfo) in
            result.insert(iconInfo.sizeInPixels)
        }

        // create output folder
        print("Creating app icon set in \(outputFolderPath)")
        
        let folderPath = outputFolderPath.appendingPathComponent(appIconSetName)
        
        do {
            try fileManager.createDirectory(at: folderPath, withIntermediateDirectories: true)
        } catch {
            throw AppIconSetError.failedToMakeDir
        }
        

        // create scaled icons
        try imageSizesInPixels.forEach { sizeInPixels in
            let iconFileName = appIconFileName(from: sizeInPixels)
            print("Creating \(iconFileName)")
            if let imageData = sourceImage.imagePNGRepresentation(widthInPixels: sizeInPixels, heightInPixels: sizeInPixels) {
                
                let outputFile = folderPath.appendingPathComponent(iconFileName)
                do {
                    try imageData.write(to: outputFile)
                } catch {
                    throw AppIconSetError.failedToWriteFile
                }
            }
        }

        // create Contents.json file
        let contentsJSONFile = folderPath.appendingPathComponent("Contents.json")
        print("Creating \(contentsJSONFile)")

        let entries = items.reduce(into: [String]()) { (result: inout [String], iconInfo) in
            let iconFileName = appIconFileName(from: iconInfo.sizeInPixels)
            let sizeDim = iconInfo.size.cleanValue
            let size = "\(sizeDim)x\(sizeDim)"
            let scale = "\(iconInfo.scale.cleanValue)x"

            var entryLines = [String]()

            entryLines.append("\n\"size\":\"\(size)\"")
            entryLines.append("\n\"idiom\":\"\(iconInfo.idiom.contentJSONFormat)\"")

            if iconInfo.role != .any {
                entryLines.append("\n\"role\":\"\(iconInfo.role.contentJSONFormat)\"")
            }

            if iconInfo.subtype != .any {
                entryLines.append("\n\"subtype\":\"\(iconInfo.subtype.contentJSONFormat)\"")
            }

            entryLines.append("\n\"filename\":\"\(iconFileName)\"")
            entryLines.append("\n\"scale\":\"\(scale)\"")

            result.append("\n{\(entryLines.joined(separator: ","))\n}")
        }.joined(separator: ",")

        let contents = "{\n\"images\":[\(entries)\n],\n\"info\":{\n\"version\":1,\n\"author\":\"xcode\"\n}\n}"
        do {
            try contents.write(to: contentsJSONFile, atomically: true, encoding: .utf8)
        } catch {
            throw AppIconSetError.failedToWriteFile
        }
    }

    public init(iconInfoItems: [IconInfo]) {
        self.iconInfoItems = iconInfoItems
    }

    private func appIconFileName(from sizeInPixels: CGFloat) -> String {
        return "appicon_\(sizeInPixels.cleanValue).png"
    }
}
