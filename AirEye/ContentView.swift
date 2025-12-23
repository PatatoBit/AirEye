//
//  ContentView1.swift
//  AirEye
//
//  Created by Patato on 20/12/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    var body: some View {
        if !hasCompletedOnboarding {
                OnboardingView()
        } else {
            TabView {
                // Tab 1: Live Camera
                LiveCameraView()
                    .tabItem {
                        Label("Live Feed", systemImage: "camera.viewfinder")
                    }
                
                // Tab 2: Photo Library
                PhotoAnalysisView()
                    .tabItem {
                        Label("Library", systemImage: "photo")
                    }
                
            }
        }
    }
}


#Preview {
    ContentView()
}
