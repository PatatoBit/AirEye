//
//  ContentView1.swift
//  AirEye
//
//  Created by Patato on 20/12/25.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
  @State private var selectedTab: Int = 0
  @Namespace private var animation

  var body: some View {
    if !hasCompletedOnboarding {
      OnboardingView()
    } else {
      ZStack(alignment: .top) {
        // Content
        if selectedTab == 0 {
          LiveCameraView()
        } else {
          PhotoAnalysisView()
        }

        // Custom Top Tab Selector
        HStack {
          Spacer()
          HStack(spacing: 0) {
            // Tab 0: Camera
            Button {
              withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = 0
              }
            } label: {
              Image(systemName: "camera.fill")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 80, height: 34)
                .background {
                  if selectedTab == 0 {
                    Capsule()
                      .fill(Color.gray.opacity(0.5))
                      .matchedGeometryEffect(id: "activeTab", in: animation)
                  }
                }
            }

            // Tab 1: Photo
            Button {
              withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = 1
              }
            } label: {
              Image(systemName: "photo.fill")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 80, height: 34)
                .background {
                  if selectedTab == 1 {
                    Capsule()
                      .fill(Color.gray.opacity(0.5))
                      .matchedGeometryEffect(id: "activeTab", in: animation)
                  }
                }
            }
          }
          .padding(3)
          .background(Color.black.opacity(0.8))
          .clipShape(Capsule())
          Spacer()
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
