//
//  ContentView.swift
//  AirEye
//
//  Created by Patato on 20/12/25.
//

import CoreML
import PhotosUI
import SwiftUI
import Vision

struct LiveCameraView: View {
  @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
  @StateObject private var cameraManager = CameraManager()
  @State private var showCaptureResult = false

  // Gallery Analysis State
  @State private var selectedItems: [PhotosPickerItem] = []
  @State private var galleryResults: [GalleryResult] = []
  @State private var showGalleryResults = false
  @State private var isAnalyzing = false

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
                  .lineLimit(1)
                  .minimumScaleFactor(0.8)

                Text("AQI Index: \(cameraManager.currentAQI)")
                  .font(.subheadline)
                  .fontWeight(.medium)
                  .foregroundStyle(.black.opacity(0.9))
              }
              .frame(maxWidth: .infinity, alignment: .leading)

              Image(systemName: "chevron.right.circle.fill")
                .font(.title2)
                .foregroundStyle(.black.opacity(0.8))
            }
            .padding(12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            .padding(.horizontal)
          }

          // Controls Area
          HStack(spacing: 40) {
            // Spacer to balance layout
            Spacer()
              .frame(width: 50)

            // Capture Button
            Button {
              cameraManager.capturePhoto()
            } label: {
              ZStack {
                Circle()
                  .stroke(.white, lineWidth: 4)
                  .frame(width: 80, height: 80)
                Circle()
                  .fill(.white)
                  .frame(width: 70, height: 70)
              }
              .shadow(radius: 10)
            }

            // Gallery Button
            PhotosPicker(selection: $selectedItems, matching: .images) {
              Image(systemName: "photo.on.rectangle")
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            }
            .disabled(isAnalyzing)

          }
          .padding(.bottom, 10)
        }
        .padding(.bottom, 8)

        if isAnalyzing {
          Color.black.opacity(0.4).ignoresSafeArea()
          ProgressView("Analyzing...")
            .padding()
            .background(Color.white)
            .cornerRadius(10)
        }
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {

          NavigationLink(
            destination: AboutView(),
            label: {
              Image(systemName: "info")
            })

        }
      }
      .onChange(of: cameraManager.capturedImage) { newImage in
        if newImage != nil {
          showCaptureResult = true
        }
      }
      .onChange(of: selectedItems) { newItems in
        guard !newItems.isEmpty else { return }
        analyzeImages(newItems)
      }
      .navigationDestination(isPresented: $showCaptureResult) {
        if let image = cameraManager.capturedImage {
          CaptureResultView(image: image, aqi: cameraManager.capturedAQI)
        }
      }
      .navigationDestination(isPresented: $showGalleryResults) {
        GalleryResultsView(results: galleryResults)
      }
    }
  }

  private func analyzeImages(_ items: [PhotosPickerItem]) {
    isAnalyzing = true
    galleryResults = []

    Task {
      var results: [GalleryResult] = []

      for item in items {
        if let data = try? await item.loadTransferable(type: Data.self),
          let uiImage = UIImage(data: data)
        {

          if let aqi = await predictAQI(for: uiImage) {
            results.append(GalleryResult(image: uiImage, aqi: aqi))
          }
        }
      }

      await MainActor.run {
        self.galleryResults = results
        self.selectedItems = []  // Reset selection
        self.isAnalyzing = false
        if !results.isEmpty {
          self.showGalleryResults = true
        }
      }
    }
  }

  private func predictAQI(for image: UIImage) async -> Int? {
    return await withCheckedContinuation { continuation in
      DispatchQueue.global(qos: .userInitiated).async {
        do {
          let config = MLModelConfiguration()
          let model = try AirQualityRegressor(configuration: config)
          let visionModel = try VNCoreMLModel(for: model.model)

          let request = VNCoreMLRequest(model: visionModel) { request, error in
            guard let results = request.results as? [VNCoreMLFeatureValueObservation],
              let firstResult = results.first,
              let multiArray = firstResult.featureValue.multiArrayValue
            else {
              continuation.resume(returning: nil)
              return
            }

            let logVal = multiArray[0].doubleValue
            let finalAQI = AQIHelpers.calculateAQI(fromLogOutput: logVal)
            continuation.resume(returning: finalAQI)
          }

          guard let ciImage = CIImage(image: image) else {
            continuation.resume(returning: nil)
            return
          }

          request.imageCropAndScaleOption = .centerCrop
          let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
          try handler.perform([request])

        } catch {
          print("Error: \(error)")
          continuation.resume(returning: nil)
        }
      }
    }
  }

}

#Preview {
  LiveCameraView()
}
