//
//  ContentView.swift
//  AirEye
//
//  Created by Patato on 20/12/25.
//

import SwiftUI

struct LiveCameraView: View {
    @StateObject private var cameraManager = CameraManager()
    
    var body: some View {
        ZStack {
            // Background: Live Camera
            CameraPreview(session: cameraManager.session)
                .ignoresSafeArea()
            
            // Overlay: AQI Data
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    Text("Air Quality Index")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Text("\(cameraManager.currentAQI)")
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .foregroundStyle(getAQIColor(cameraManager.currentAQI))
                    
                    Text(getAQIDescription(cameraManager.currentAQI))
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }
                .padding(30)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.bottom, 50)
            }
        }
    }
    
    // Helper for Colors
    func getAQIColor(_ aqi: Int) -> Color {
        switch aqi {
        case 0...50: return .green
        case 51...100: return .yellow
        case 101...150: return .orange
        case 151...200: return .red
        case 201...300: return .purple
        default: return Color(red: 0.6, green: 0, blue: 0) // Maroon
        }
    }
    
    // Helper for Text
    func getAQIDescription(_ aqi: Int) -> String {
        switch aqi {
        case 0...50: return "Good"
        case 51...100: return "Moderate"
        case 101...150: return "Unhealthy for Sensitive Groups"
        case 151...200: return "Unhealthy"
        case 201...300: return "Very Unhealthy"
        default: return "Hazardous"
        }
    }
}
