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
      LiveCameraView()
    }
  }
}

#Preview {
  ContentView()
}
