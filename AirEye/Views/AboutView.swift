//
//  AboutView.swift
//  AirEye
//
//  Created by Patato on 1/1/26.
//

import SwiftUI

struct AboutView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("About AirEye")
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .headingStyle()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("AirEye is an image-based air quality estimation app, built as part of a comprehensive research project exploring computer vision for environmental monitoring.")
                            .font(.body)
                            .fontWeight(.semibold)
                        
                        Text("The journey starts with real-time data collection: a custom webcam scraper gathers images from public cameras worldwide, capturing diverse atmospheric conditions. This fresh data integrates seamlessly with established datasets like VAQI-1—a rich repository of outdoor air quality images, alongside specialized collections from pioneering papers such as 'Image-Based Air Quality Estimation Using Convolutional Neural Network' (featuring CNNs optimized by genetic algorithms for 95.44% accuracy) and 'Image-Based Air Quality Estimation' (blending meteorological insights with image features).")
                            .font(.body)
                        
                        Text("The core CNN model undergoes rigorous training, with genetic algorithms fine-tuning hyperparameters to deliver robust precision, recall, and generalization across varied scenes. Simply upload an image, and AirEye provides an instant AQI estimation powered by this research-grade pipeline.")
                            .font(.body)
                        
                        Text("⚠️ **Disclaimer:** This is an experimental estimation tool only. Not for official or critical use—always verify with certified sources like government AQI monitors.")
                            .font(.caption)
                            .foregroundStyle(.orange)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Button(action: {
                            if let url = URL(string: "https://github.com/PatatoBit/WebcamScraper") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Label("GitHub Repo (Webcam Scraper)", systemImage: "link.circle.fill")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.bordered)
                        
                        Button(action: {
                            if let url = URL(string: "https://www.kaggle.com/code/patatotato/aireye-full") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Label("Kaggle Notebook (Full Training)", systemImage: "link.circle.fill")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.bordered)
                        
                        Button(action: {
                            hasCompletedOnboarding = false
                        }) {
                            Label("Reset Onboarding", systemImage: "arrow.clockwise")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Spacer()
        }
        .fullFrameStyle()
        .padding()
    }
}

#Preview {
    AboutView()
}
