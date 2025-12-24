//
//  Extensions.swift
//  AirEye
//
//  Created by Patato on 24/12/25.
//

import SwiftUI
import UIKit

extension UIImage {
    /// Extracts the color at a specific point in the image
    func pixelColor(at point: CGPoint) -> Color? {
        guard let cgImage = self.cgImage,
              let provider = cgImage.dataProvider,
              let providerData = provider.data,
              let data = CFDataGetBytePtr(providerData) else {
            return nil
        }

        let width = cgImage.width
        let height = cgImage.height
        
        let x = Int(point.x)
        let y = Int(point.y)
        
        // Check if the point is within the image bounds
        if x < 0 || x >= width || y < 0 || y >= height {
            return nil
        }

        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let bytesPerRow = cgImage.bytesPerRow
        let pixelOffset = (y * bytesPerRow) + (x * bytesPerPixel)

        // Safe check to avoid index out of range
        if pixelOffset > CFDataGetLength(providerData) - 4 { return nil }

        let r = CGFloat(data[pixelOffset]) / 255.0
        let g = CGFloat(data[pixelOffset + 1]) / 255.0
        let b = CGFloat(data[pixelOffset + 2]) / 255.0

        return Color(red: r, green: g, blue: b)
    }
    
    /// Helper to return raw RGB integers (0-255)
    func pixelValues(at point: CGPoint) -> (r: Int, g: Int, b: Int)? {
        // Re-calculate directly to ensure we get raw integers
        guard let cgImage = self.cgImage,
              let provider = cgImage.dataProvider,
              let providerData = provider.data,
              let data = CFDataGetBytePtr(providerData) else {
            return nil
        }
        
        let width = cgImage.width
        let x = Int(point.x)
        let y = Int(point.y)
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let bytesPerRow = cgImage.bytesPerRow
        let pixelOffset = (y * bytesPerRow) + (x * bytesPerPixel)
        
        if pixelOffset > CFDataGetLength(providerData) - 4 { return nil }

        let r = Int(data[pixelOffset])
        let g = Int(data[pixelOffset + 1])
        let b = Int(data[pixelOffset + 2])
        
        return (r, g, b)
    }
}
