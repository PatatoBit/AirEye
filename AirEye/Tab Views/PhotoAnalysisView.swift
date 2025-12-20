//
//  PhotoAnalystView.swift
//  AirEye
//
//  Created by Patato on 20/12/25.
//

import SwiftUI
import PhotosUI
import Vision
import CoreML

struct PhotoAnalysisView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var predictedAQI: Int? = nil
    @State private var isAnalyzing: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 1. Image Display Area
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                } else {
                    ContentUnavailableView {
                        Label("No Image Selected", systemImage: "photo.badge.plus")
                    } description: {
                        Text("Select a photo from your library to analyze.")
                    }
                }
                
                // 2. Results Area
                if isAnalyzing {
                    ProgressView("Analyzing Air Quality...")
                } else if let aqi = predictedAQI {
                    VStack(spacing: 10) {
                        Text("\(aqi)")
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                            .foregroundStyle(AQIHelpers.getColor(for: aqi))
                        
                        Text(AQIHelpers.getDescription(for: aqi))
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                }
                
                Spacer()
                
                // 3. Picker Button
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select Photo", systemImage: "photo.on.rectangle")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Photo Analysis")
            .onChange(of: selectedItem) { newItem in
                Task {
                    // Load image from picker
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        await MainActor.run {
                            self.selectedImage = uiImage
                            self.predictedAQI = nil // Reset old result
                        }
                        analyzeImage(uiImage)
                    }
                }
            }
        }
    }
    
    // Core Logic: Run 1-time prediction
    private func analyzeImage(_ image: UIImage) {
        isAnalyzing = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // 1. Prepare Model
                let config = MLModelConfiguration()
                let model = try AirQualityRegressor(configuration: config)
                let visionModel = try VNCoreMLModel(for: model.model)
                
                // 2. Prepare Request
                let request = VNCoreMLRequest(model: visionModel) { request, error in
                    guard let results = request.results as? [VNCoreMLFeatureValueObservation],
                          let firstResult = results.first,
                          let multiArray = firstResult.featureValue.multiArrayValue else { return }
                    
                    let logVal = multiArray[0].doubleValue
                    let finalAQI = AQIHelpers.calculateAQI(fromLogOutput: logVal)
                    
                    DispatchQueue.main.async {
                        self.predictedAQI = finalAQI
                        self.isAnalyzing = false
                    }
                }
                
                // 3. Run Handler
                guard let ciImage = CIImage(image: image) else { return }
                // Use .centerCrop to match your camera logic (and training data)
                request.imageCropAndScaleOption = .centerCrop
                
                let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
                try handler.perform([request])
                
            } catch {
                print("Error: \(error)")
                DispatchQueue.main.async { self.isAnalyzing = false }
            }
        }
    }
}
