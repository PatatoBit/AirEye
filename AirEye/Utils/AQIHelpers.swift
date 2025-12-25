//
//  AQIHelpers.swift
//  AirEye
//
//  Created by Patato on 20/12/25.
//

import SwiftUI

struct AQIHelpers {
  // Math: Reverses the Logarithmic training logic
  static func calculateAQI(fromLogOutput logValue: Double) -> Int {
    let LOG_ALPHA = 9.0
    let AQI_MAX = 300.0

    // Formula: y = (e^log_y - 1) / alpha
    let y = (exp(logValue) - 1.0) / LOG_ALPHA
    let aqi = y * AQI_MAX

    return max(0, Int(aqi))  // Ensure no negative numbers
  }

  // UI: Get Color
  static func getColor(for aqi: Int) -> Color {
    switch aqi {
    case 0...50: return .green
    case 51...100: return .yellow
    case 101...150: return .orange
    case 151...200: return .red
    case 201...300: return .purple
    default: return Color(red: 0.6, green: 0, blue: 0)  // Maroon
    }
  }

  // UI: Get Description
  static func getDescription(for aqi: Int) -> String {
    switch aqi {
    case 0...50: return "Good"
    case 51...100: return "Moderate"
    case 101...150: return "Unhealthy (Sensitive)"
    case 151...200: return "Unhealthy"
    case 201...300: return "Very Unhealthy"
    default: return "Hazardous"
    }
  }

  // UI: Get Icon Name
  static func getIconName(for aqi: Int) -> String {
    switch aqi {
    case 0...50: return "Good"
    case 51...100: return "Moderate"
    case 101...150: return "USG"
    case 151...200: return "Unhealthy"
    case 201...300: return "VeryUnhealthy"
    default: return "Hazardous"
    }
  }
}
