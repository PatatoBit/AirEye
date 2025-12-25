//  MachineLearning.swift
//  AirEye
//
//  Created by Patato on 22/12/25.
//

import Combine
import SwiftUI

struct MachineLearning: View {
  @State private var isTraining = false

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        // Header Section
        Text("From Examples to Expertise")
          .labelStyle()

        VStack(alignment: .leading, spacing: 20) {
          Text("The Learning Loop")
            .headingStyle()

          Text("The model analyzed 12,902 images, each labeled with its actual AQI.")
        }

        // Interactive Training Demo
        TrainingSimulationView()
          .padding(.vertical)

        Text(
          "By constantly comparing its guess to the truth and correcting its own math, it taught itself to recognize the visual signatures of bad air."
        )

        Spacer()
      }
      .padding()
    }
  }
}

// MARK: - Training Simulation View
struct TrainingSimulationView: View {
  // Ensure these names match your Asset Catalog exactly
  let examples = [
    "12-17_day_AQI33_Clouds",
    "13-18_day_AQI114_Clouds",
    "13-53_day_AQI18_Clouds",
    "13-53_day_AQI71_Clouds",
    "14-01_day_AQI29_Clear",
    "14-21_day_AQI31_Clouds",
  ]

  @State private var currentIndex = 0
  @State private var predictedAQI: Int = 0
  @State private var currentStep: TrainingStep = .idle
  @State private var accuracy: Double = 0.0
  @State private var epochCount = 0

  let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()

  enum TrainingStep {
    case idle, guessing, revealing, learning
  }

  var currentFile: ParsedFile {
    parseFilename(examples[currentIndex])
  }

  var body: some View {
    VStack(spacing: 20) {
      // 1. The "Image" Card
      ZStack {
        // Background Layer: The Webcam Image
        GeometryReader { geo in
          Image(examples[currentIndex])
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
        // Fallback gradient if image is missing in Assets
        .background(
          LinearGradient(
            colors: [Color.gray.opacity(0.3), Color.blue.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        // Dark overlay to ensure text readability against the photo
        .overlay(Color.black.opacity(0.2))

        // Overlay Info: Weather Icon & Day/Night
        VStack {
          HStack {
            VStack(alignment: .leading) {
              Image(systemName: iconForWeather(currentFile.weather))
                .font(.title)
                .foregroundColor(.white)
              Text(currentFile.weather)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
            }
            Spacer()
            Text(currentFile.dayNight.capitalized)
              .font(.caption)
              .fontWeight(.bold)
              .padding(.vertical, 4)
              .padding(.horizontal, 8)
              .background(.ultraThinMaterial)
              .cornerRadius(4)
              .foregroundColor(.white)
          }
          Spacer()
        }
        .padding()

        // Overlay Info: Filename (Data Source)
        VStack {
          Spacer()
          HStack {
            Image(systemName: "doc.text.fill")
            Text(examples[currentIndex])
              .font(.system(.caption, design: .monospaced))
              .lineLimit(1)
          }
          .foregroundColor(.white)
          .padding(8)
          .background(.ultraThinMaterial)
          .cornerRadius(8)
          .padding(.bottom, 8)
        }
      }
      .frame(height: 220)
      .cornerRadius(16)
      .shadow(radius: 5)
      .padding(.horizontal)

      // 2. The Learning Loop UI
      HStack(spacing: 30) {
        // Prediction Column
        VStack {
          Text("Model Guess")
            .font(.caption)
            .foregroundColor(.secondary)

          if currentStep == .idle {
            Text("...")
              .font(.title2)
              .fontWeight(.bold)
          } else {
            Text("\(predictedAQI)")
              .font(.title)
              .fontWeight(.heavy)
              .foregroundColor(currentStep == .guessing ? .orange : .primary)
              .scaleEffect(currentStep == .guessing ? 1.1 : 1.0)
              .animation(.spring(), value: currentStep)
          }
        }

        Image(systemName: "arrow.right")
          .foregroundColor(.secondary)

        // Ground Truth Column
        VStack {
          Text("Actual AQI")
            .font(.caption)
            .foregroundColor(.secondary)

          if currentStep == .revealing || currentStep == .learning {
            Text("\(currentFile.aqi)")
              .font(.title)
              .fontWeight(.heavy)
              .foregroundColor(colorForAQI(currentFile.aqi))
              .transition(.opacity)
          } else {
            Text("?")
              .font(.title2)
              .foregroundColor(.secondary.opacity(0.3))
          }
        }
      }
      .padding()
      .background(Color(UIColor.secondarySystemBackground))
      .cornerRadius(12)
      .padding(.horizontal)

      // 3. Status Bar
      VStack(spacing: 8) {
        if currentStep == .learning {
          HStack {
            Image(systemName: "gearshape.2.fill")
              .rotationEffect(.degrees(360))
              .animation(
                .linear(duration: 1).repeatForever(autoreverses: false), value: currentStep)
            Text("Minimizing Loss...")
              .font(.caption)
              .fontWeight(.bold)
          }
          .foregroundColor(.blue)
        } else if currentStep == .guessing {
          Text("Extracting features...")
            .font(.caption)
            .foregroundColor(.secondary)
        } else {
          Text(" ")
            .font(.caption)
        }

        ProgressView(value: accuracy)
          .tint(.green)
          .padding(.horizontal, 40)
      }
    }
    .onReceive(timer) { _ in
      advanceSimulation()
    }
  }

  // MARK: - Logic & Helpers

  func advanceSimulation() {
    withAnimation {
      switch currentStep {
      case .idle, .learning:
        currentIndex = (currentIndex + 1) % examples.count
        currentStep = .guessing
        // Simulate learning: noise decreases as we see more examples (epochCount)
        let learningCurve = max(1, 60 - (epochCount * 12))
        let randomError = Int.random(in: -learningCurve...learningCurve)
        predictedAQI = max(0, currentFile.aqi + randomError)

      case .guessing:
        currentStep = .revealing

      case .revealing:
        currentStep = .learning
        epochCount += 1
        // Cap visual accuracy at 95%
        accuracy = min(0.95, 0.1 + (Double(epochCount) * 0.1))
      }
    }
  }

  struct ParsedFile {
    let time: String
    let dayNight: String
    let aqi: Int
    let weather: String
  }

  func parseFilename(_ filename: String) -> ParsedFile {
    let components = filename.components(separatedBy: "_")
    guard components.count >= 4 else {
      return ParsedFile(time: "", dayNight: "", aqi: 0, weather: "")
    }

    let time = components[0]
    let dayNight = components[1]
    let aqiString = components[2].replacingOccurrences(of: "AQI", with: "")
    let aqi = Int(aqiString) ?? 0
    let weather = components[3]

    return ParsedFile(time: time, dayNight: dayNight, aqi: aqi, weather: weather)
  }

  func colorForAQI(_ value: Int) -> Color {
    switch value {
    case 0...50: return .green
    case 51...100: return .yellow
    case 101...150: return .orange
    case 151...200: return .red
    case 201...300: return .purple
    default: return .brown
    }
  }

  func iconForWeather(_ weather: String) -> String {
    switch weather.lowercased() {
    case "clouds": return "cloud.fill"
    case "clear": return "sun.max.fill"
    case "haze": return "sun.haze.fill"
    case "mist": return "cloud.fog.fill"
    case "dust": return "wind"
    default: return "cloud"
    }
  }
}

#Preview {
  MachineLearning()
}
