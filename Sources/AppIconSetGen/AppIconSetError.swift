//
//  File.swift
//  
//
//  Created by Charles Yiu on 8/11/2023.
//

import Foundation

public enum AppIconSetError: Error {
    case failedToWriteFile
    case failedToMakeDir
}
extension AppIconSetError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToWriteFile:
            return "Failed to save image"
        case .failedToMakeDir:
            return "Failed to make directory"
        }
    }
}
