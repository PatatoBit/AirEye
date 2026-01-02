//
//  AirQualityLevelsView.swift
//  AirEye
//
//  Created by Patato on 22/12/25.
//

import SwiftUI

struct AQILevelData: Identifiable {
  let id = UUID()
  let name: String
  let range: String
  let image: String
  let aqiValue: Int
}

struct AirQualityLevelsView: View {
  @State private var selectedLevel: AQILevelData?

  let levels: [AQILevelData] = [
    AQILevelData(name: "Good", range: "0-50", image: "Good", aqiValue: 25),
    AQILevelData(name: "Moderate", range: "51-100", image: "Moderate", aqiValue: 75),
    AQILevelData(
      name: "Unhealthy for Sensitive groups", range: "101-200", image: "USG", aqiValue: 125),
    AQILevelData(name: "Unhealthy", range: "201-250", image: "Unhealthy", aqiValue: 175),
    AQILevelData(name: "Very Unhealthy", range: "251-300", image: "VeryUnhealthy", aqiValue: 250),
    AQILevelData(name: "Hazardous", range: "300+", image: "Hazardous", aqiValue: 350),
  ]

  var body: some View {
    VStack(alignment: .leading) {
      Text("Levels of air quality")
        .font(.title)
        .fontDesign(.rounded)
        .bold()

      Text("Tap on a level to see health guides")
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.bottom, 8)

      ForEach(levels) { level in
        AirQualityRow(name: level.name, aqiRange: level.range, photoPath: level.image)
          .contentShape(Rectangle())  // Make the whole row tappable
          .onTapGesture {
            selectedLevel = level
          }
      }

      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
    .sheet(item: $selectedLevel) { level in
      AQIGuideView(level: level)
    }
  }
}

struct AQIGuideView: View {
  let level: AQILevelData
  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack(spacing: 24) {

      Text(level.name)
        .font(.title)
        .fontDesign(.rounded)
        .bold()
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .padding(.top, 16)

      Image(level.image)
        .resizable()
        .scaledToFit()
        .frame(width: 120, height: 120)
        .clipShape(Circle())
        .shadow(radius: 5)

      VStack(alignment: .leading, spacing: 16) {
        Text("Health Guide")
          .font(.headline)
          .foregroundColor(.secondary)

        VStack(alignment: .leading, spacing: 12) {
          ForEach(AQIHelpers.getHealthGuide(for: level.aqiValue), id: \.self) { guide in
            HStack(alignment: .top, spacing: 12) {
              Image(systemName: "info.circle.fill")
                .foregroundColor(.blue)
                .font(.body)

              Text(guide)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            }
          }
        }
      }
      .padding()
      .background(Color(UIColor.secondarySystemBackground))
      .cornerRadius(16)
      .padding(.horizontal)

      Spacer()
    }
    .presentationDetents([.medium, .large])
  }
}

struct AirQualityRow: View {
  var name: String = "Good"
  var aqiRange: String = "0-50"
  var photoPath: String = "Good"

  var body: some View {
    HStack(spacing: 16) {
      Image("\(photoPath)")
        .resizable()
        .frame(width: 50, height: 50)
        .clipShape(Circle())

      VStack(alignment: .leading) {
        Text("\(name)")
          .font(.title3)
          .fontDesign(.rounded)
          .fontWeight(.medium)

        Text("\(aqiRange)")
      }
    }
  }
}

#Preview {
  AirQualityLevelsView()
}
