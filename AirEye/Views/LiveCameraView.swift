//
//  ContentView.swift
//  AirEye
//
//  Created by Patato on 20/12/25.
//

import SwiftUI

struct LiveCameraView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @StateObject private var cameraManager = CameraManager()
    
    var body: some View {
        NavigationStack {
            if !hasCompletedOnboarding {
                
                OnboardingView()
            } else {
                ZStack {
                    // Background: Live Camera
                    CameraPreview(session: cameraManager.session)
                        .ignoresSafeArea()
                    
                    // Overlay: AQI Data
                    VStack {
                        Spacer()
                        
                        NavigationLink {
                            AirQualityLevelsView()
                        } label: {
                            VStack {
                                Text(AQIHelpers.getDescription(for: cameraManager.currentAQI))
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.white)
                                
                                Text("\(cameraManager.currentAQI)")
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(AQIHelpers.getColor(for: cameraManager.currentAQI))
                            .cornerRadius(100)
                            
                        }
                    }
                    .padding(.bottom, 8)
                }
            }
        }
    }
    
    
}


#Preview {
    LiveCameraView()
}
