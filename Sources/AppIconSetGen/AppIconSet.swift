//
//  AppIconSet.swift
//  AppIconSetGenCore
//
//  Created by Attila Bencze on 11/05/2017.
//
//

import Cocoa
import Foundation
import PathKit

struct AppIconSet {
    let iconInfoItems: [IconInfo]

    func createOnDisk(sourceImage: NSImage, outputFolderPath: String, appIconSetName: String) throws {
        let items = iconInfoItems
        let imageSizesInPixels = items.reduce(into: Set<CGFloat>()) { (result: inout Set<CGFloat>, iconInfo) in
            result.insert(iconInfo.sizeInPixels)
        }

        // create output folder
        let folderPath = Path(outputFolderPath) + Path("\(appIconSetName).appiconset")
        print("Creating app icon set in \(folderPath)")

        try? folderPath.delete() // ignore errors
        do {
            try folderPath.mkpath()
        } catch {
            throw AppIconSetError.failedToMakeDir
        }

        // create scaled icons
        try imageSizesInPixels.forEach { sizeInPixels in
            let iconFileName = appIconFileName(from: sizeInPixels)
            print("Creating \(iconFileName)")
            if let imageData = sourceImage.imagePNGRepresentation(widthInPixels: sizeInPixels, heightInPixels: sizeInPixels) {
                let outputFile = folderPath + Path(iconFileName)
                do {
                    try outputFile.write(imageData as Data)
                } catch {
                    throw AppIconSetError.failedToWriteFile
                }
            }
        }

        // create Contents.json file
        let contentsJSONFile = folderPath + Path("Contents.json")
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
            try contentsJSONFile.write(contents)
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
