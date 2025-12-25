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
      ZStack {
        // Background: Live Camera
        CameraPreview(session: cameraManager.session)
          .ignoresSafeArea()

        VStack {

          Spacer()

          // Overlay: AQI Data
          NavigationLink {
            AirQualityLevelsView()
          } label: {
            HStack(spacing: 16) {
              Image(AQIHelpers.getIconName(for: cameraManager.currentAQI))
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(Circle())

              VStack(alignment: .leading, spacing: 2) {
                Text(AQIHelpers.getDescription(for: cameraManager.currentAQI))
                  .font(.system(size: 20, weight: .bold, design: .rounded))
                  .foregroundStyle(AQIHelpers.getColor(for: cameraManager.currentAQI))
                  .multilineTextAlignment(.leading)

                Text("AQI Index: \(cameraManager.currentAQI)")
                  .font(.subheadline)
                  .fontWeight(.medium)
                  .foregroundStyle(.black.opacity(0.9))
              }

              Spacer()

              Image(systemName: "chevron.right.circle.fill")
                .font(.title2)
                .foregroundStyle(.black.opacity(0.8))
            }
            .padding(12)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            .padding(.horizontal)
          }
        }
        .padding(.bottom, 8)
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            hasCompletedOnboarding = false
          } label: {
            Image(systemName: "repeat")
          }

        }
      }
    }
  }

}

#Preview {
  LiveCameraView()
}
