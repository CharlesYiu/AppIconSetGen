# AppIconSetGen
modified [abeintopalo/AppIconSetGen](https://github.com/abeintopalo/AppIconSetGen) so you can use the package in another project programmatically.  
it is unstable; i do not recommend you use it in production.  
## Example Usage
```swift
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
```
## Definitions
```swift
public func generateAppIconSet(image: NSImage, type: AppIconSetType, name: String, output: URL) throws
public func generateAppIconSet(image: NSImage, types: [AppIconSetType], name: String, output: URL) throws
public func generateAppIconSet(image: CIImage, type: AppIconSetType, name: String, output: URL) throws
public func generateAppIconSet(image: CIImage, types: [AppIconSetType], name: String, output: URL) throws

// All functions above throws AppIconSetError
public enum AppIconSetError: Error {
    case failedToWriteFile
    case failedToMakeDir
}
